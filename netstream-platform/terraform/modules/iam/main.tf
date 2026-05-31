# JenkinsMasterRole
resource "aws_iam_role" "jenkins_master_role" {
  name               = "${var.project_name}-JenkinsMasterRole"
  assume_role_policy = jsonencode(local.jenkins_master_config.trust_policy)
}
# 1.Attach the Operational Permissions
resource "aws_iam_role_policy" "jenkins_master_policy" {
  name   = "${var.project_name}-JenkinsMasterPolicy"
  role   = aws_iam_role.jenkins_master_role.id
  policy = jsonencode(local.jenkins_master_config.operational_policy)
}
#2. Create the EC2 Instance Profile Container
resource "aws_iam_instance_profile" "jenkins_master_instance_profile" {
  name = "${var.project_name}-JenkinsMasterInstanceProfile"
  role = aws_iam_role.jenkins_master_role.name
}

# JenkinsAgentRole
resource "aws_iam_role" "jenkins_agent_role" {
  name               = "${var.project_name}-JenkinsAgentRole"
  assume_role_policy = jsonencode(local.jenkins_agent_config.trust_policy)
}
#1. Allow Jenkins Agent to assume the Jenkins Master Role
resource "aws_iam_role_policy" "jenkins_agent_policy" {
  name   = "${var.project_name}-JenkinsAgentPolicy"
  role   = aws_iam_role.jenkins_agent_role.id
  policy = jsonencode(local.jenkins_agent_config.operational_policy)
}

#2. Create the EC2 Instance Profile Container
resource "aws_iam_instance_profile" "jenkins_agent_instance_profile" {
  name = "${var.project_name}-JenkinsAgentInstanceProfile"
  role = aws_iam_role.jenkins_agent_role.name
}

#TerraformExecutionRole
resource "aws_iam_role" "terraform_execution_role" {
  name               = "${var.project_name}-TerraformExecutionRole"
  assume_role_policy = jsonencode(local.tf_exec_role_config.trust_policy)
}
resource "aws_iam_role_policy" "terraform_execution_policy" {
  name   = "${var.project_name}-TerraformExecutionPolicy"
  role   = aws_iam_role.terraform_execution_role.id
  policy = jsonencode(local.tf_exec_role_config.operational_policy)
}



