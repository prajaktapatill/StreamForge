output "jenkins_master_role_arn" {
  value = aws_iam_role.jenkins_master_role.arn
}
output "jenkins_master_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_master_instance_profile.name
}
output "jenkins_agent_role_arn" {
  value = aws_iam_role.jenkins_agent_role.arn
}
output "jenkins_agent_instance_profile_name" {
  value = aws_iam_instance_profile.jenkins_agent_instance_profile.name
}
output "terraform_execution_role_arn" {
  value = aws_iam_role.terraform_execution_role.arn
}
