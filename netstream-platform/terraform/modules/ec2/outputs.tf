output "jenkins_master_instance_id" {
  description = "The ID of the Jenkins Master EC2 instance."
  value       = aws_instance.jenkins_master.id
}

output "jenkins_master_public_ip" {
  description = "The public IP address assigned to the Jenkins Master."
  value       = aws_instance.jenkins_master.public_ip
}

output "jenkins_master_private_ip" {
  description = "The private IP address assigned to the Jenkins Master."
  value       = aws_instance.jenkins_master.private_ip
}

output "jenkins_agent_instance_ids" {
  description = "List of IDs of the Jenkins Agent EC2 instances."
  value       = aws_instance.jenkins_agent[*].id
}

output "jenkins_agent_private_ips" {
  description = "List of private IP addresses assigned to the Jenkins Agent instances."
  value       = aws_instance.jenkins_agent[*].private_ip
}
