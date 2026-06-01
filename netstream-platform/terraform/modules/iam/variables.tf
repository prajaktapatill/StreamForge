variable "project_name" {
  description = "The name of the project to which the IAM resources will be applied."
  type        = string
  default     = "netstream"
}
variable "environment" {
  description = "The environment for which the IAM resources will be applied (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}
variable "aws_region" {
  description = "The AWS region where the IAM resources will be created."
  type        = string
  default     = "us-east-1"
}
variable "account_id" {
  description = "The AWS account ID where the IAM resources will be created."
  type        = string
  default     = "" #cloudops-sandbox account ID
}
variable "sso_user_arn" {
  description = "The ARN of the SSO user that will be allowed to assume the TerraformExecutionRole."
  type        = string
}
