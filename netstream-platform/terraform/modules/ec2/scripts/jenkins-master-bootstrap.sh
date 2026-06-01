#!/bin/bash
set -e

# Update system and install Java 17 runtime
apt-get update -y
apt-get install -y openjdk-17-jdk openjdk-17-jre curl gnupg

# Add official Jenkins keyring and repository split
install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://jenkins.io | gpg --dearmor -o /etc/apt/keyrings/jenkins::keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/jenkins::keyring.gpg] https://jenkins.io binary/" | tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Install Jenkins service
apt-get update -y
apt-get install -y jenkins

# Enable and start services cleanly
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins
