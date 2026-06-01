# ==============================================================================
# GLOBAL PROJECT METADATA
# ==============================================================================
variable "project_name" {
  description = "The unified core naming prefix used across all provisioned resources."
  type        = string
  default     = "netstream"
}

variable "environment" {
  description = "The active infrastructure deployment stage (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "aws_region" {
  description = "The explicit AWS Region targeted for infrastructure resource creation."
  type        = string
  default     = "us-east-1"
}

# ==============================================================================
# SECURE IDENTITY & ACCESS MANAGEMENT (IAM) VALUES
# ==============================================================================
variable "account_id" {
  description = "The AWS account ID where the IAM resources will be created."
  type        = string
  default     = "" # Provide your cloudops-sandbox account ID here
}

variable "sso_user_arn" {
  description = "The ARN of the SSO user that will be allowed to assume the TerraformExecutionRole."
  type        = string
  default     = "arn:aws:iam::<account_id>:user/<sso_user_name>"
}

# ==============================================================================
# NETWORK TOPOLOGY CONFIGURATION (VPC)
# ==============================================================================
variable "cidr_block" {
  description = "The primary parent IPv4 network block range allocated for the VPC boundary."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "The list array of targeted Availability Zones for multi-AZ subnet distribution."
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "allowed_admin_cidr" {
  description = "The whitelisted firewall entry range permitted to connect to the Jenkins port 8080 UI."
  type        = string
  default     = "0.0.0.0/0" # Update this to your office or home VPN IP range for real security
}

variable "route_anywhere" {
  description = "The standard CIDR definition shorthand used to represent global outbound internet routing."
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "A universal dictionary of optional resource key-value metadata pairs."
  type        = map(string)
  default     = {}
}

# ==============================================================================
# COMPUTE SIZE & HARDWARE STORAGE CONFIGURATIONS
# ==============================================================================
variable "instance_type" {
  description = "The EC2 hardware instance type sizing template assigned to Master and Agent launch specifications."
  type        = string
  default     = "t3.medium"
}

variable "volume_size" {
  description = "The baseline storage capacity in GB assigned for root encrypted gp3 storage disks."
  type        = number
  default     = 30
}

variable "ami_map" {
  description = "A regional mapping dictionary containing verified official Canonical Ubuntu 24.04 LTS AMIs."
  type        = map(string)
  default     = {
    "us-east-1" = "ami-0c94855ba95c71c99" # Ubuntu 24.04 LTS (x86_64)
  }
}

# ==============================================================================
# JENKINS MASTER AUTO SCALING CAPACITY BOUNDS
# ==============================================================================
variable "jenkins_master_desired_capacity" {
  description = "The target baseline pool running count of Jenkins Master servers (Strictly locked to 1)."
  type        = number
  default     = 1
}

variable "jenkins_master_min_size" {
  description = "The absolute lower pool sizing boundary constraint allowed for the active Master ASG."
  type        = number
  default     = 1
}

variable "jenkins_master_max_size" {
  description = "The absolute upper pool sizing boundary constraint allowed for the active Master ASG."
  type        = number
  default     = 1
}

# ==============================================================================
# JENKINS BUILD AGENT AUTO SCALING CAPACITY BOUNDS
# ==============================================================================
variable "agent_desired_count" {
  description = "The initial target running baseline volume count of worker build agent nodes."
  type        = number
  default     = 1
}

variable "agent_min_size" {
  description = "The absolute lowest scaling floor size allowed for active Jenkins worker instances."
  type        = number
  default     = 1
}

variable "agent_max_size" {
  description = "The peak high-workload scaling ceiling allowance cap allowed for the active Agent ASG."
  type        = number
  default     = 1 # Sized to 1 per your requirements; bump this up to 3 or higher later for elastic scaling
}
