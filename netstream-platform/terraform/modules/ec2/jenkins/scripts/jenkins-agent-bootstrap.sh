#!/bin/bash
set -e

# Install prerequisite utilities
apt-get update -y
apt-get install -y openjdk-17-jdk git curl ca-certificates gnupg

# Add official Docker package index keyrings
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://docker.com | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://docker.com $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker binaries
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

# Create workspace path and align permissions
mkdir -p /home/ubuntu/jenkins_workspace
chown -R ubuntu:ubuntu /home/ubuntu/jenkins_workspace

# Set up user groups so build pipelines can communicate with Docker engine sockets natively
usermod -aG docker ubuntu
systemctl enable docker
systemctl start docker
