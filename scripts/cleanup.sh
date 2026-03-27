#!/bin/bash

set -e

echo "Cleaning up DevSecOps deployment..."

# Delete Argo CD applications
kubectl delete application -n argocd --all || true

# Delete Kubernetes resources
kubectl delete namespace microservices argocd || true

# Destroy Terraform infrastructure
cd terraform
terraform destroy -auto-approve

echo "Cleanup complete!"