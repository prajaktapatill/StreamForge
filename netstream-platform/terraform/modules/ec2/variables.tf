variable "project_name" {
  description = "The name of the project to which the EC2 resources will be applied."
  type        = string
}

variable "environment" {
  description = "The environment for which the EC2 resources will be applied (e.g., dev, staging, prod)."
  type        = string
}

variable "aws_region" {
  description = "The AWS region where the EC2 resources will be created."
  type        = string  
}

variable "instance_type" {
  description = "The EC2 instance type to use for the created instances."
  type        = string
}

variable "volume_size" {
  description = "The size of the root EBS volume in GB."
  type        = number
}

variable "ami_map" {
  type        = map(string)
  description = "Hardcoded verified map of official Canonical Ubuntu 24.04 LTS x86_64 AMIs"
  default     = {
    "us-east-1"  = "ami-04a81a99f5ec58529" 
    "us-east-2"  = "ami-09040d770ffe2224f" 
    "us-west-2"  = "ami-03cceb19496c25679" 
    "ap-south-1" = "ami-012586e92ee2fe102" 
  }
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets."
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets."
  type        = list(string)
}

variable "jenkins_master_sg_id" {
  description = "The ID of the security group for the Jenkins Master instance."
  type        = string
}

variable "jenkins_agent_sg_id" {
    description = "The ID of the security group for the Jenkins Agent instances."   
    type        = string
}

variable "jenkins_master_iam_instance_profile_name" {
  description = "The name of the IAM instance profile to attach to the Jenkins Master EC2 instance."
  type        = string
}

variable "jenkins_agent_iam_instance_profile_name" {
  description = "The name of the IAM instance profile to attach to the Jenkins Agent EC2 instances."
  type        = string
}
