#1. JENKINS MASTER SECURITY GROUP (Public)
resource "aws_security_group" "jenkins_master_sg" {
  name        = "${var.project_name}-${var.environment}-jenkins-master-sg"
  description = "Security group for Jenkins Master"
  vpc_id      = aws_vpc.this.id

  ingress {
    description      = "Allow HTTP from anywhere (for Jenkins UI)"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [var.allowed_admin_cidr]
  }
 # Inbound: SSH is NOT needed here because we attached ssm:* permissions for Session Manager!
 # Outbound: Full internet mapping for software updates & talking to agents
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.route_anywhere]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-jenkins-master-sg"
      Type = "Security"
    },
  )
}
#2.JENKINS MASTER SECURITY GROUP (Private)
resource "aws_security_group" "jenkins_agent_sg" {
  name        = "${var.project_name}-${var.environment}-jenkins-agent-sg"
  description = "Security group for Jenkins Agents"
  vpc_id      = aws_vpc.this.id 
  
  # Inbound: ONLY trust traffic coming from the Master Security Group ID
  ingress {
    description      = "Allow all traffic from Jenkins Master SG"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups  = [aws_security_group.jenkins_master_sg.id] # Strict group referencing
  }
  # Outbound: Full internet mapping for software updates & talking to master
  egress {
    description      = "Allow all outbound traffic" 
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.route_anywhere]
    }

    tags = merge(  
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-jenkins-agent-sg"
      Type = "Security"
    },
  )
}