#!/bin/bash
set -e

echo "Installing Jenkins on Ubuntu..."

#Add the correct 2026 Key
#Azure VMs sometimes have strict permissions on /usr/share/keyrings, so we'll ensure the directory exists first.
sudo mkdir -p /etc/apt/keyrings
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2026.key

#Create the new Source List entry for Jenkins, referencing the keyring
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/" | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update system
sudo apt-get clean
sudo apt-get update
sudo apt-get upgrade -y

# Install Java
sudo apt-get install -y openjdk-17-jre

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
sudo systemctl start dockersudo systemctl daemon-reload
sudo systemctl enable docker

echo "Jenkins installation complete!"
echo "Access Jenkins at: http://$(hostname -I | awk '{print $1}'):8080"