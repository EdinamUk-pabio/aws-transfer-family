variable "role" {
  type = object({
    policy_name = string
    role_name = string
  })
}

variable "bucket_name" {
  description = "Name of the s3 bucket"
}