# DevSecOps End-to-End Project on Azure

Complete CI/CD pipeline with Jenkins, Kubernetes, and Argo CD on Microsoft Azure.

## Architecture Overview

- **Infrastructure**: Azure Kubernetes Service (AKS) provisioned with Terraform
- **Registry**: Azure Container Registry (ACR) for storing Docker images
- **CI/CD**: Jenkins for building and pushing container images
- **Deployment**: Argo CD for GitOps-based continuous deployment
- **Microservices**: Three sample services (User, Order, Product)

## Prerequisites

- Azure subscription
- Terraform installed
- Azure CLI installed
- kubectl installed
- Docker installed
- Git configured

## Quick Start

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/devsecops-azure-cicd.git
   cd devsecops-azure-cicd