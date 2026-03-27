#!/bin/bash
set -e

echo "Installing Jenkins on Ubuntu..."

# Update system
sudo apt-get update
sudo apt-get upgrade -y

# Install Java
sudo apt-get install -y openjdk-11-jre-headless

# Add Jenkins repository
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

# Install Jenkins
sudo apt-get update
sudo apt-get install -y jenkins

# Install Docker (for Jenkins to build containers)
sudo apt-get install -y docker.io
sudo usermod -aG docker jenkins

# Install kubectl
sudo apt-get install -y curl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Start Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl start docker
sudo systemctl enable docker

echo "Jenkins installation complete!"
echo "Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"