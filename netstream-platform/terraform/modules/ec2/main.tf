# 1. Jenkins Master EC2 Instance
resource "aws_instance" "jenkins_master" {
  ami           = lookup(var.ami_map, var.aws_region, var.ami_map["us-east-1"])
  instance_type = var.instance_type
  subnet_id     = var.public_subnet_ids[0]

  iam_instance_profile   = var.jenkins_master_iam_instance_profile_name
  vpc_security_group_ids = [var.jenkins_master_sg_id]

  # Allocate a standard gp3 storage disk
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    encrypted             = true
    delete_on_termination = true
  }
  tags = {
    Name        = "${var.project_name}-${var.environment}-jenkins-master"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Compute"
  }
}
# 2. Jenkins Agent EC2 Instance
resource "aws_instance" "jenkins_agent" {
  count         = 1
  ami           = lookup(var.ami_map, var.aws_region, var.ami_map["us-east-1"])
  instance_type = var.instance_type
  subnet_id     = var.private_subnet_ids[count.index % length(var.private_subnet_ids)]

  iam_instance_profile   = var.jenkins_agent_iam_instance_profile_name
  vpc_security_group_ids = [var.jenkins_agent_sg_id]

  # Allocate a standard gp3 storage disk
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.volume_size
    encrypted             = true
    delete_on_termination = true
  }
  tags = {
    Name        = "${var.project_name}-${var.environment}-jenkins-agent-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
    Type        = "Compute"
  }
}
