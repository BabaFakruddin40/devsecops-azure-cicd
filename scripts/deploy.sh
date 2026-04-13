#!/bin/bash

set -e

echo "Starting DevSecOps deployment on Azure..."

# Initialize Terraform
cd ../terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

echo "Infrastructure deployed successfully!"

# Get AKS credentials
RESOURCE_GROUP=$(terraform output -raw resource_group_name)
CLUSTER_NAME=$(terraform output -raw aks_cluster_name)
az aks get-credentials --resource-group $RESOURCE_GROUP --name $CLUSTER_NAME

# Install Argo CD
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --server-side --force-conflicts

echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/argocd-server -n argocd

# Apply Argo CD applications
kubectl apply -f ../argo-cd/app-of-apps.yaml

echo "Deployment complete! Check Argo CD dashboard to monitor applications."