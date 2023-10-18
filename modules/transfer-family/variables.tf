variable "lambda_function_arn" {
  description = "lambda function arn"
}

variable "endpoint_type" {
  description = "sftp endpoint type"
  type = string
}

variable "identity_provider_type" {
  description = "sftp identity provider type"
  type = string
}

variable "storage_domain" {
  description = "sftp storage domain"
  type = string
}

variable "sftp-log-group" {
  
}