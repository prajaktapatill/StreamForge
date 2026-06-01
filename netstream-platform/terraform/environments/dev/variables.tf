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
  default     = "arn:aws:iam::<account_id>:user/<sso_user_name>"
}
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "route_anywhere" {
  type        = string
  default     = "0.0.0.0/0"
  description = "The CIDR block definition used to represent all outbound internet traffic routes."
}
variable "volume_size" {
  description = "The size of the root EBS volume in GB."
  type        = number
  default     = 30
}
variable "instance_type" {
  description = "The EC2 instance type to use for the created instances."
  type        = string
  default     = "t3.medium"
}
variable "ami_map" {
    description = "A map of AWS region to AMI ID to use for the EC2 instances."
    type        = map(string)
    default     = {
        "us-east-1" = "ami-0c94855ba95c71c99" #Ubuntu 24.04 LTS
    }
} 
variable "allowed_admin_cidr" {
  type        = string
  default     = "0.0.0.0/0" # <-- The actual value originates here for Dev
  description = "The whitelist range allowed to access the Jenkins port 8080 UI."
}

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
  default     = "arn:aws:iam::<account_id>:user/<sso_user_name>"
}
