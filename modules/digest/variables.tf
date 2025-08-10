variable "url" {
  description = "The URL to the digest file"
  type        = string
}


variable "filename" {
  type        = string
  description = "Exact filename to match (case-sensitive) in the digest file"
}

variable "algorithm" {
  type        = string
  description = "Digest (hash) algorithm to use (MD5, SHA1, SHA256, SHA384, SHA512) - the digest file will determine what is available"
  validation {
    condition     = contains(["MD5", "SHA1", "SHA256", "SHA512"], upper(var.algorithm))
    error_message = "hash_algorithm must be one of: MD5, SHA1, SHA256, SHA384, SHA512."
  }
}