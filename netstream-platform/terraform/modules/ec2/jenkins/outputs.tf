output "jenkins_master_asg_id" {
  description = "The unique tracking ID of the Jenkins Master Auto Scaling Group."
  value       = aws_autoscaling_group.jenkins_master_asg.id
}

output "jenkins_master_asg_name" {
  description = "The deployment name of the Jenkins Master Auto Scaling Group."
  value       = aws_autoscaling_group.jenkins_master_asg.name
}

output "jenkins_agent_asg_id" {
  description = "The unique tracking ID of the Jenkins Agent Auto Scaling Group."
  value       = aws_autoscaling_group.jenkins_agent_asg.id
}

output "jenkins_agent_asg_name" {
  description = "The deployment name of the Jenkins Agent Auto Scaling Group."
  value       = aws_autoscaling_group.jenkins_agent_asg.name
}
