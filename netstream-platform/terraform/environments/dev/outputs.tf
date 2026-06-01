output "jenkins_master_management_url" {
  description = "The direct web browser URL to reach your Jenkins Master."
  value       = "http://${module.ec2.jenkins_master_public_ip}:8080"
}

output "jenkins_master_public_ip" {
  description = "The public IP address of the Jenkins Master for direct SSH access."
  value       = module.ec2.jenkins_master_public_ip
}

output "jenkins_master_private_ip" {
  description = "The internal VPC IP address of the Jenkins Master."
  value       = module.ec2.jenkins_master_private_ip
}

output "jenkins_agent_private_ips" {
  description = "The internal VPC IP addresses of all deployed Jenkins Agents."
  value       = module.ec2.jenkins_agent_private_ips
}
