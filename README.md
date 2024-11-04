
# Hextris on Kind Deployment Using Terraform

This repository automates the deployment of [Hextris](https://github.com/Hextris/hextris), a game application, on a local Kubernetes cluster using [Kind](https://kind.sigs.k8s.io/) and [Helm](https://helm.sh/). The infrastructure provisioning and configuration are managed by [Terraform](https://www.terraform.io/).

## Table of Contents
1. [Repository Structure](#repository-structure)
2. [Prerequisites](#prerequisites)
3. [Setup Instructions](#setup-instructions)
4. [Terraform Configuration](#terraform-configuration)
5. [Helm Deployment](#helm-deployment)
6. [Accessing the Application](#accessing-the-application)
7. [Cleaning Up](#cleaning-up)
8. [Additional Resources](#additional-resources)

---

## Repository Structure

The repository is organized as follows:

```plaintext
hextris-kind/
├── charts/
│   └── hextris/                    # Helm chart for deploying Hextris on Kubernetes
├── terraform/                      # Terraform files for managing the infrastructure
│   ├── init.tf
│   ├── main.tf
│   ├── outputs.tf
│   └── version.tf
├── .gitignore                      # Git ignore file
├── .pre-commit-config.yaml         # Pre-commit hooks configuration
├── Dockerfile                      # Dockerfile for building the Hextris application image
└── README.md                       # Project documentation
```

## Prerequisites

Before starting, ensure the following tools are installed:

1. **Docker** - Required for running the Kind cluster.
2. **Kind** - To create and manage a local Kubernetes cluster in Docker.
3. **Kubectl** - Kubernetes CLI for interacting with the cluster.
4. **Helm** - For managing Kubernetes applications using Helm charts.
5. **Terraform** - To provision and configure the Kind cluster and Helm deployment.
6. **Optional: Pre-commit**

## Setup Instructions

### Step 1: Clone the Repository

```bash
git clone <repository-url>
cd hextris-kind
```

### Step 2: (Optional) Build the Hextris Docker Image

While this repository includes a `Dockerfile` to build the Hextris image locally, Kind cannot directly access images from the local Docker registry. Therefore, we use a pre-built image hosted on Docker Hub in the Helm chart deployment. If you need to modify the image, you can build it locally and [push](https://kind.sigs.k8s.io/docs/user/quick-start/#loading-an-image-into-your-cluster) it to kind.

This project uses Chainguard images for deploying Hextris due to their focus on security, minimalism, and performance. Chainguard images follow a "distroless" approach, meaning they include only the essential components needed to run the application, which minimizes potential vulnerabilities and reduces the attack surface.

Build the Docker image:

```bash
docker build -t hextris-nginx:latest .
```

## Terraform Configuration

### Step 3: Initialize Terraform

Navigate to the `terraform` directory and initialize the Terraform configuration:

```bash
cd terraform
terraform init
```

This downloads necessary plugins and prepares the Terraform environment.

### Step 4: Apply the Terraform Configuration

Run the following command to create the Kind cluster and deploy Hextris:

```bash
terraform apply
```

Terraform will:
- Create a Kind cluster.
- Generate kubeconfig file

#### Export `KUBECONFIG` file:

Export the `KUBECONFIG` file so `kubectl` can access the Kind cluster created by Terraform:

```bash
export KUBECONFIG=~/kind-config  # Replace with the actual path if different
```

### Step 5: Verify the Kind Cluster

After the Terraform apply completes, verify that the Kind cluster and nodes are running:

```bash
kubectl get nodes
```

## Helm Deployment

### Step 6: Deploy Hextris with Helm

Navigate to the `charts/hextris` directory:

```bash
cd ../charts/hextris
```

Deploy the Helm chart:

```bash
helm install hextris .
```

This command deploys the Hextris application using the Helm chart included in this repository.

## Accessing the Application

By default, the application is deployed as a `ClusterIP` service, which is accessible only within the cluster. To access the application locally, use `kubectl port-forward`.

1. **Get the Pod Name**:

   ```bash
   export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=hextris,app.kubernetes.io/instance=hextris" -o jsonpath="{.items[0].metadata.name}")
   ```

2. **Port-forward to Access Hextris**:

   ```bash
   kubectl port-forward $POD_NAME 8080:8080
   ```

3. **Access the Application**:

   Open your browser and go to `http://127.0.0.1:8080` to play Hextris.

## Cleaning Up

To remove the Kind cluster and all related resources:

1. **Destroy Terraform-managed Resources**:

   ```bash
   terraform destroy
   ```

   This will delete the Kind cluster and any infrastructure created by Terraform.

2. **Uninstall Helm Release**:

   If you want to remove the Helm release only, you can use:

   ```bash
   helm uninstall hextris
   ```

## Additional Resources

- [Kind Documentation](https://kind.sigs.k8s.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Terraform Documentation](https://www.terraform.io/docs/)
- [Pre-commit Documentation](https://pre-commit.com/)

---
