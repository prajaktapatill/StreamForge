# 1. JENKINS MASTER: LAUNCH TEMPLATE & AUTO SCALING GROUP
# Launch Template: Defines how the Master instance should be built
resource "aws_launch_template" "jenkins_master_lt" {
  name_prefix   = "${var.project_name}-${var.environment}-jenkins-master-lt-"
  image_id      = lookup(var.ami_map, var.aws_region, var.ami_map["us-east-1"])
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.jenkins_master_iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.jenkins_master_sg_id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  # SEPARATE USER DATA: Reads external master script file and converts to Base64 automatically
  user_data = filebase64("${path.module}/scripts/jenkins_master_user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-jenkins-master"
      Environment = var.environment
      Project     = var.project_name
      Type        = "Compute"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Auto Scaling Group: Guarantees exactly 1 Master is ALWAYS alive
resource "aws_autoscaling_group" "jenkins_master_asg" {
  desired_capacity = var.jenkins_master_desired_capacity
  max_size         = var.jenkins_master_max_size
  min_size         = var.jenkins_master_min_size
  launch_template {
    id      = aws_launch_template.jenkins_master_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.public_subnet_ids
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-jenkins-master-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
# 2. JENKINS AGENT: LAUNCH TEMPLATE & AUTO SCALING GROUP
# Launch Template: Defines how the Agent instances should be built
resource "aws_launch_template" "jenkins_agent_lt" {
  name_prefix   = "${var.project_name}-${var.environment}-jenkins-agent-lt-"
  image_id      = lookup(var.ami_map, var.aws_region, var.ami_map["us-east-1"])
  instance_type = var.instance_type
  iam_instance_profile {
    name = var.jenkins_agent_iam_instance_profile_name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.jenkins_agent_sg_id]
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = var.volume_size
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  # SEPARATE USER DATA: Reads external master script file and converts to Base64 automatically
  user_data = filebase64("${path.module}/scripts/jenkins_agent_user_data.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "${var.project_name}-${var.environment}-jenkins-agent"
      Environment = var.environment
      Project     = var.project_name
      Type        = "Compute"
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
# Auto Scaling Group: Scales the Agent fleet based on demand
resource "aws_autoscaling_group" "jenkins_agent_asg" {
  desired_capacity = var.agent_desired_count
  max_size         = var.agent_max_count
  min_size         = var.agent_min_count
  launch_template {
    id      = aws_launch_template.jenkins_agent_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = var.private_subnet_ids
  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment}-jenkins-agent-asg"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
  }
}
