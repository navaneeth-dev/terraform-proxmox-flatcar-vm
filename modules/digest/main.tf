/*
  Get the remote digest file.  This is expected to be of the form:

  ```
    # MD5 HASH
    d9ea9f324ede50e723455324e7d37d4f  flatcar_production_qemu_uefi_image.img
    # SHA1 HASH
    520c51e05788470097ff68707a998ff8c59cf4b3  flatcar_production_qemu_uefi_image.img
    # SHA512 HASH
    ef51ffe856d1f6ac313b7bb7436ae ... a7cdb84a3e6ca0bc93db  flatcar_production_qemu_uefi_image.img
 ```

  This module doesn't check the signature of the digest. This should be done at a later time.
  Checking the digest mitigates against errors, not against malicious supply chain style attacks.

  see:
    - https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http
*/
data "http" "digest_file" {
  url = var.url
}

locals {
  algo_upper = upper(var.algorithm)

  # Escape regex special characters in filename
  filename_escaped = replace(
    var.filename,
    # Escape characters: \ . + * ? [ ^ ] $ ( ) { } = ! < > | : -
    # We'll escape them with a backslash \\
    "([\\\\\\.\\+\\*\\?\\[\\^\\]\\$\\(\\)\\{\\}=!<>\\|:\\-])",
    "\\\\$1"
  )

  /*
      Terraform uses the RE2 regular expression language; not PCRE. RE2 is a subset of
      what is supported by PCRE, so whitespace and comments are not supported in the
      regex pattern ('x' mode).

      Reminder: The string is firstly a terraform string template, that will have variable
      interpolation performed first. The is expand the '$...' and the first level of
      back slashes.

      see:
        - https://github.com/google/re2/wiki/Syntax
  */
  pattern_pcre = <<-EOT
    (?m)                                   # Multi-line, ignore whitespace, allow comments
    ^
    \\# \\s*                                # comment prefix
     (?i: ${var.algorithm} )                # case insensitively match the algorithm
    \\s+ HASH \\s*                          # match the 'HASH' suffix
    \\n                                     # Newline after header
    ([a-f0-9]+)                             # Capture the hex checksum
    \\s+                                    # One or more spaces
    ${local.filename_escaped}               # Match the filename exactly (case-sensitive)
    $$                                      # End of line
  EOT
  pattern_re2 = "(?m)^\\#\\s*(?i:${var.algorithm})\\s+HASH\\s*\\n([a-fA-F0-9]+)\\s+${local.filename_escaped}$$"

  /*
    see:
      - https://developer.hashicorp.com/terraform/language/functions/regexall#limitations
  */
  matches = regexall(local.pattern_re2, data.http.digest_file.response_body)

  /*
      The digest/hash should be the one and only matching hex string.
  */
  digest = length(local.matches) > 0 ? local.matches[0][0] : null
}

# Explicitly fail if no match found
resource "null_resource" "verify" {
  triggers = {
    digest_present = local.digest != null ? "true" : "false"
  }

  lifecycle {
    precondition {
      condition     = local.digest != null
      error_message = "Digest for algorithm '${local.algo_upper}' not found in digest file at ${var.url}"
    }
  }
}
