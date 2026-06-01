# ==============================================================================
# 1. IDENTITY TIER: IAM Instance Profiles Module
# ==============================================================================
module "ec2_iam_instance_profiles" {
  source       = "../../modules/iam"
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  account_id   = var.account_id
  sso_user_arn = var.sso_user_arn
}

# ==============================================================================
# 2. NETWORK TIER: VPC Core Networking & Security Firewall Groups
# ==============================================================================
module "vpc" {
  source             = "../../modules/vpc"
  availability_zones = var.availability_zones
  allowed_admin_cidr = var.allowed_admin_cidr
  cidr_block         = var.cidr_block
  project_name       = var.project_name
  environment        = var.environment
  tags               = var.tags
  route_anywhere     = var.route_anywhere
}


# Setup EC2 instances for Jenkins Master and Agents
module "ec2" {
  source = "../../modules/ec2/jenkins"

  # Core Context Global Variables
  project_name  = var.project_name
  environment   = var.environment
  aws_region    = var.aws_region
  instance_type = var.instance_type
  volume_size   = var.volume_size

  # Network subnets derived straight from VPC module outputs
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  # Firewall group tokens derived straight from VPC security rules
  jenkins_master_sg_id = module.vpc.jenkins_master_sg_id
  jenkins_agent_sg_id  = module.vpc.jenkins_agent_sg_id

  # Server role metadata derived straight from IAM module outputs
  jenkins_master_iam_instance_profile_name = module.ec2_iam_instance_profiles.jenkins_master_instance_profile_name
  jenkins_agent_iam_instance_profile_name  = module.ec2_iam_instance_profiles.jenkins_agent_instance_profile_name

  # Capacity configuration limits for the Master ASG
  jenkins_master_desired_capacity = var.jenkins_master_desired_capacity
  jenkins_master_max_size         = var.jenkins_master_max_size
  jenkins_master_min_size         = var.jenkins_master_min_size

  # Capacity configuration limits for the Agent ASG
  agent_desired_count = var.agent_desired_count
  agent_max_count     = var.agent_max_size
  agent_min_count     = var.agent_min_size
}
