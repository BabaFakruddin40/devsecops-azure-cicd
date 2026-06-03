#!/bin/bash
# Script to install and configure ArgoCD for the skills app

set -e

# 1. Install ArgoCD
kubectl create namespace argocd || true
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for ArgoCD server to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment/argocd-server -n argocd

# 2. Port-forward ArgoCD API server (background)
echo "Port-forwarding ArgoCD server to http://localhost:8080 ..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
PORT_FORWARD_PID=$!
sleep 5

# 3. Get ArgoCD admin password
ARGOCD_PWD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
echo "ArgoCD admin password: $ARGOCD_PWD"

# 4. Apply the Application manifest for skills app
kubectl apply -f k8s-manifests/argocd-app.yaml

echo "---"
echo "ArgoCD UI: http://localhost:8080"
echo "Username: admin"
echo "Password: $ARGOCD_PWD"
echo "You can now login to ArgoCD UI and sync the skills-app application."
echo "To stop port-forwarding, run: kill $PORT_FORWARD_PID"
