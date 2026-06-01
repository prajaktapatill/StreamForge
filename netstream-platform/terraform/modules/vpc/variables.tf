variable "availability_zones" {
  type        = list(string)
  description = "The target AWS availability zones for subnet distribution."
}

variable "cidr_block" {
  type        = string
  description = "The primary IPv4 CIDR block allocation for the VPC network boundary."
}

variable "project_name" {
  type        = string
  description = "The unified core naming prefix used across all provisioned resources."
}

variable "environment" {
  type        = string
  description = "The active infrastructure deployment stage (e.g., dev, staging, prod)."
}

variable "tags" {
  type        = map(string)
  default     = {} # Safe to keep: empty map fallback is fine for optional metadata
}

variable "route_anywhere" {
  type        = string
  default     = "0.0.0.0/0" # Safe to keep: This is a static networking standard, not a custom environment setting
  description = "The CIDR block definition used to represent all outbound internet traffic routes."
}

variable "allowed_admin_cidr" {
  type        = string
  description = "The whitelisted firewall entry range permitted to connect to the Jenkins UI."
}
