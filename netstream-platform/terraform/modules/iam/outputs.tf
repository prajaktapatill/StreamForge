output "jenkins_master_role_arn" {
  description = "The Amazon Resource Name mapping to the Jenkins Master Core IAM Role."
  value       = aws_iam_role.jenkins_master_role.arn
}

output "jenkins_master_instance_profile_name" {
  description = "The dynamic profile token used to attach master permissions onto EC2 assets."
  value       = aws_iam_instance_profile.jenkins_master_instance_profile.name
}

output "jenkins_agent_role_arn" {
  description = "The Amazon Resource Name mapping to the Jenkins Agent Worker IAM Role."
  value       = aws_iam_role.jenkins_agent_role.arn
}

output "jenkins_agent_instance_profile_name" {
  description = "The dynamic profile token used to attach agent permissions onto EC2 workers."
  value       = aws_iam_instance_profile.jenkins_agent_instance_profile.name
}

output "terraform_execution_role_arn" {
  description = "The high-privilege automation execution fallback target ARN."
  value       = aws_iam_role.terraform_execution_role.arn
}
