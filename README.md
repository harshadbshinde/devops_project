# 🚀 Portfolio DevOps Automation

## 📌 Project Overview

This project is an end-to-end **DevOps and Kubernetes deployment project** for a Portfolio web application.

The project uses **Docker, GitHub Actions, Terraform, AWS EKS, Kubernetes, and Argo CD** to automate the application deployment process.

The main workflow is:

```text
Developer
   |
   | Push code to GitHub
   v
Portfolio Docker Image Pipeline
   |
   | Build Docker Image
   | Push Image
   v
Docker Hub
   |
   v
Terraform Pipeline
   |
   | Terraform Init
   | Terraform Plan
   | Terraform Apply
   v
AWS EKS Cluster
   |
   | Create Argo CD namespace
   | Install Argo CD
   | Check Argo CD
   v
ArgoCD Application Pipeline
   |
   | Apply application.yml
   v
Argo CD
   |
   | Sync Kubernetes manifests
   v
Kubernetes
   |
   +---- Deployment
   |
   +---- Service
   |
   +---- NetworkPolicy
   |
   v
Portfolio Application

📂 Project Structure
portfolio-devops-automation/
│
├── .github/
│   └── workflows/
│       ├── automation.yml
│       ├── portfolio-image.yml
│       └── terraform.yml
│
├── argocd/
│   └── application.yml
│
├── css/
│   └── style.css
│
├── js/
│   └── script.js
│
├── eks-yml/
│   ├── deployment.yml
│   ├── net.yml
│   └── service.yml
│
├── environment/
│   └── dev/
│       ├── main.tf
│       ├── provider.tf
│       ├── terraform.tfvars
│       └── variable.tf
│
├── modules/
│   ├── aws-cni.tf
│   ├── eks.tf
│   ├── iam-role.tf
│   ├── nodegroup.tf
│   ├── variable.tf
│   └── vpc.tf
│
├── Dockerfile
├── index.html
└── README.md


🔄 CI/CD Pipeline

This project uses three GitHub Actions workflows.

1. Portfolio Docker Image
          |
          v
2. Terraform
          |
          v
3. ArgoCD Application

Each workflow has a separate responsibility.

1️⃣ Portfolio Docker Image Pipeline
Workflow
.github/workflows/portfolio-image.yml
Purpose

The first pipeline creates a Docker image of the Portfolio application and pushes it to Docker Hub.

Workflow
GitHub Push
    |
    v
Checkout Source Code
    |
    v
Login to Docker Hub
    |
    v
Build Docker Image
    |
    v
List Docker Images
    |
    v
Push Image to Docker Hub

The Docker image is built using:

docker build -t <docker-username>/my-portfolio-image .

The image is pushed using:

docker push <docker-username>/my-portfolio-image
Docker Image
<docker-username>/my-portfolio-image

The Docker image contains the Portfolio web application and is later used by Kubernetes.

2️⃣ Terraform Infrastructure Pipeline
Workflow
.github/workflows/terraform.yml
Purpose

After the Docker workflow completes successfully, the Terraform workflow provisions the AWS infrastructure.

The Terraform pipeline performs:

AWS Authentication
       |
       v
Terraform Init
       |
       v
Terraform Plan
       |
       v
Terraform Apply
       |
       v
AWS EKS Cluster
       |
       v
Update kubeconfig
       |
       v
Check EKS Nodes
       |
       v
Create Argo CD Namespace
       |
       v
Install Argo CD
       |
       v
Wait for Argo CD
       |
       v
Check Argo CD


☁️ AWS Infrastructure

Terraform is used to create the Kubernetes infrastructure in AWS.

The project contains Terraform configuration under:

environment/dev/

and reusable Terraform modules under:

modules/
Terraform Environment
environment/dev/
├── main.tf
├── provider.tf
├── terraform.tfvars
└── variable.tf
Terraform Modules
modules/
├── aws-cni.tf
├── eks.tf
├── iam-role.tf
├── nodegroup.tf
├── variable.tf
└── vpc.tf

These modules are used to define the AWS networking, IAM, EKS cluster, node group, and related infrastructure.

☸️ Amazon EKS

The Terraform pipeline creates an Amazon EKS cluster.

The GitHub Actions workflow then connects to the cluster using:

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name my-eks-cluster

The cluster is verified with:

kubectl get nodes

This confirms that the GitHub Actions runner can communicate with the EKS cluster.

🔄 Argo CD Installation

After EKS is created, the Terraform pipeline automatically creates the Argo CD namespace:

kubectl create namespace argocd \
  --dry-run=client \
  -o yaml | kubectl apply -f -

Argo CD is then installed into the cluster.

The workflow waits for the Argo CD server to become available and checks the Argo CD Pods and Services.

Example checks:

kubectl get pods -n argocd
kubectl get svc -n argocd


3️⃣ ArgoCD Application Automation Pipeline
Workflow
.github/workflows/automation.yml
Purpose

The third pipeline automatically creates or updates the Argo CD Application after the Terraform pipeline completes successfully.

The workflow performs:

Terraform Pipeline
       |
       v
AWS Authentication
       |
       v
Update kubeconfig
       |
       v
Check EKS Cluster
       |
       v
Apply Argo CD Application
       |
       v
Check Argo CD Application

The Argo CD Application is applied using:

kubectl apply \
  --validate=false \
  -f argocd/application.yml

The application is checked using:

kubectl get application portfolio -n argocd


🔁 GitOps Deployment with Argo CD

The project uses Argo CD to deploy Kubernetes resources from Git.

The Argo CD configuration is located at:

argocd/application.yml

The application points Argo CD to the Kubernetes manifests stored in the repository.

GitHub Repository
       |
       v
argocd/application.yml
       |
       v
     Argo CD
       |
       v
     AWS EKS
       |
       v
Kubernetes Resources

This allows Argo CD to maintain the desired application state in the Kubernetes cluster.

📦 Kubernetes Resources

The Kubernetes manifests are stored under:

eks-yml/

The directory contains:

eks-yml/
├── deployment.yml
├── net.yml
└── service.yml


🚀 Deployment
File
eks-yml/deployment.yml

The Deployment creates the Portfolio application Pods.

The Pods run the Docker image created by the Docker pipeline.

Docker Hub
    |
    v
Docker Image
    |
    v
Kubernetes Deployment
    |
    v
Portfolio Pod


🌐 Service
File
eks-yml/service.yml

The Kubernetes Service provides network access to the Portfolio application Pods.

Client
  |
  v
Service
  |
  v
Portfolio Pod
  |
  v
Container


🔐 NetworkPolicy
File
eks-yml/net.yml

The NetworkPolicy controls allowed network communication between Kubernetes workloads.

It can be used to restrict:

Ingress traffic
Egress traffic
Pod-to-Pod communication

This provides an additional network security layer for the application.

🐳 Docker

The project contains a:

Dockerfile

The Dockerfile is responsible for packaging the Portfolio application into a container image.

The general flow is:

Portfolio Source Code
        |
        v
     Dockerfile
        |
        v
   Docker Build
        |
        v
   Docker Image
        |
        v
    Docker Hub


🌐 Portfolio Application

The Portfolio frontend contains:

index.html
css/style.css
js/script.js
HTML

index.html contains the main structure and content of the Portfolio website.

CSS

css/style.css contains the styling and design of the Portfolio application.

JavaScript

js/script.js contains the JavaScript functionality and client-side interactions.

🔐 GitHub Secrets

The GitHub Actions workflows use GitHub Secrets for sensitive credentials.

Docker Hub
DOCKER_USERNAME
DOCKER_PASSWORD
AWS
AWS_ACCESS_KEY_ID_1
AWS_SECRET_KEY_1

These credentials should be stored in:

GitHub Repository
    → Settings
    → Secrets and variables
    → Actions

Sensitive credentials should never be hard-coded into YAML, Terraform, or application files.

🖥️ Manual Operations

Most of the deployment process is automated through GitHub Actions.

There are currently a few manual operational steps used to access and manage the environment from a local machine.

1. Configure kubeconfig locally

After the EKS cluster is created, configure the local machine:

aws eks update-kubeconfig \
  --region ap-south-1 \
  --name my-eks-cluster

Verify the connection:

kubectl get nodes
2. Port Forward Argo CD

To access the Argo CD UI from the local machine:

kubectl port-forward svc/argocd-server \
  -n argocd 8080:443

Then open:

https://localhost:8080

Port forwarding is currently used as the local method for accessing the Argo CD server.

🔄 Complete Project Flow
                       Git Push
                          |
                          v
             ┌────────────────────────┐
             │ Portfolio Docker Image │
             │       Pipeline          │
             └────────────┬───────────┘
                          |
                          v
                   Docker Build
                          |
                          v
                      Docker Hub
                          |
                          v
             ┌────────────────────────┐
             │   Terraform Pipeline   │
             └────────────┬───────────┘
                          |
                          v
                 Terraform Init
                          |
                          v
                 Terraform Plan
                          |
                          v
                Terraform Apply
                          |
                          v
                    AWS EKS
                          |
                          v
               Create Argo CD NS
                          |
                          v
                Install Argo CD
                          |
                          v
                  Check Argo CD
                          |
                          v
             ┌────────────────────────┐
             │ ArgoCD Application     │
             │      Pipeline           │
             └────────────┬───────────┘
                          |
                          v
               application.yml
                          |
                          v
                       Argo CD
                          |
                          v
                    AWS EKS
                          |
             ┌────────────┼────────────┐
             v            v            v
        Deployment     Service    NetworkPolicy
             |
             v
       Portfolio Application


📊 Automation Summary
Process	Status
Source code checkout	✅ Automated
Docker image build	✅ Automated
Docker image push	✅ Automated
AWS authentication	✅ Automated
Terraform initialization	✅ Automated
Terraform plan	✅ Automated
Terraform apply	✅ Automated
EKS cluster creation	✅ Automated
EKS connection in GitHub Actions	✅ Automated
EKS node verification	✅ Automated
Argo CD namespace creation	✅ Automated
Argo CD installation	✅ Automated
Argo CD health check	✅ Automated
Argo CD Application creation	✅ Automated
Kubernetes Deployment	✅ Automated through Argo CD
Kubernetes Service	✅ Automated through Argo CD
Kubernetes NetworkPolicy	✅ Automated through Argo CD
Local kubeconfig	🔶 Manual
Argo CD port forwarding	🔶 Manual


🎯 Project Objectives

This project demonstrates the following DevOps concepts:

Continuous Integration using GitHub Actions
Docker containerization
Docker image management
Infrastructure as Code using Terraform
AWS EKS provisioning
Kubernetes cluster management
Kubernetes Deployments and Services
Kubernetes NetworkPolicy
GitOps using Argo CD
Automated application deployment
CI/CD workflow chaining
Secure credential management using GitHub Secrets


🚀 Future Improvements

The project can be extended with the following improvements.

🔹 1. Argo CD External Access

Instead of local port forwarding, Argo CD can be exposed through an AWS Load Balancer or Kubernetes Ingress.

🔹 2. Automatic Image Updates

Argo CD Image Updater can be introduced so that a new Docker image automatically updates the Kubernetes Deployment.

Code Change
    |
    v
Docker Build
    |
    v
Docker Hub
    |
    v
Image Update
    |
    v
Argo CD
    |
    v
EKS

🔹 3. Monitoring

Monitoring can be added using:

Prometheus
Grafana

This can provide visibility into:

EKS nodes
Pods
CPU usage
Memory usage
Application health

🔹 4. Security Improvements

Additional security can include:

IAM least privilege
Kubernetes RBAC
Kubernetes Secrets
AWS Secrets Manager
Container image scanning
HTTPS/TLS
Stronger NetworkPolicies

🔹 5. Terraform Remote State

Terraform state can be stored remotely using an AWS backend such as S3, with appropriate state-locking and versioning practices.

🏁 Final Result

This project provides an automated DevOps workflow for deploying a Portfolio application.

GitHub
  ↓
GitHub Actions
  ↓
Docker
  ↓
Docker Hub
  ↓
Terraform
  ↓
AWS EKS
  ↓
Argo CD
  ↓
Kubernetes
  ↓
Portfolio Application

The project demonstrates how CI/CD + Infrastructure as Code + Kubernetes + GitOps can work together to automate application deployment.

👨‍💻 Project Summary

An end-to-end DevOps automation project that containerizes a Portfolio application using Docker, pushes the image to Docker Hub, provisions AWS EKS infrastructure using Terraform, automatically installs Argo CD, and deploys Kubernetes resources through a GitOps workflow using GitHub Actions and Argo CD.

⭐ Key DevOps Workflow
Docker
   ↓
Docker Hub
   ↓
Terraform
   ↓
AWS EKS
   ↓
Argo CD
   ↓
Kubernetes
   ↓
Portfolio Application
