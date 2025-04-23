
# Strapi Deployment with CI/CD and Terraform

This repository automates the deployment of a Strapi application to AWS EC2 using Docker, CI/CD via GitHub Actions, and Infrastructure as Code (IaC) with Terraform. This approach ensures a scalable and repeatable process for deploying applications to the cloud.

## Overview

This repository contains the following key components:
- **Docker**: Containerizes the Strapi application.
- **CI/CD with GitHub Actions**: Automates the process of building, pushing the Docker image, and triggering the deployment.
- **Terraform**: Automates the provisioning of AWS resources, such as EC2 instances, using Infrastructure as Code.

## Key Features
- **Automated Docker Image Build and Push**: On every push to the `main` branch, a Docker image is built and pushed to Amazon ECR.
- **Infrastructure Deployment**: AWS infrastructure (EC2 instance) is automatically created using Terraform.
- **CI/CD Pipeline**: Automated deployment triggered via GitHub Actions.

## Prerequisites

Before you begin, you need to set up a few prerequisites:

1. **AWS Account**: You must have an AWS account with appropriate permissions to manage EC2 instances, ECR (Elastic Container Registry), and related resources.
   
2. **Docker**: Install Docker on your local machine to build the Strapi application image.
   
3. **GitHub Secrets**: Store your sensitive AWS credentials and other required information in GitHub Secrets to securely access them in your workflows:
   - `AWS_ACCESS_KEY_ID`: AWS access key for authentication.
   - `AWS_SECRET_ACCESS_KEY`: AWS secret access key for authentication.
   - `AWS_REGION`: The region where your AWS resources will be deployed (e.g., `us-east-1`).
   - `ECR_REPO_NAME`: The name of your ECR repository where Docker images will be pushed.

## Setup Instructions

### 1. AWS Setup
- **Create an ECR Repository**:
  - Go to the **Amazon ECR** service in your AWS console and create a new repository. This repository will store the Docker images of your Strapi application.
  - Save the repository URL, which is typically in the form of:  
    `aws_account_id.dkr.ecr.region.amazonaws.com/repository_name`
  - Add the repository name (`ECR_REPO_NAME`) to your GitHub Secrets for later use.

- **EC2 Setup**:
  - You will use Terraform to provision an EC2 instance to host the Strapi application. This instance will automatically pull the Docker image from the ECR repository and run it.

### 2. Docker Configuration
- The **Dockerfile** defines how the Strapi application is containerized. It sets up the environment and installs the necessary dependencies to run Strapi.

- The `docker build` command in the CI/CD pipeline will package the Strapi application into a Docker image, which will then be pushed to your ECR repository.

### 3. Terraform Setup
- **Terraform Configuration**:
  - The `terraform` directory contains the infrastructure configuration files. These files define the resources needed to deploy the Strapi application, including an EC2 instance that will host the Docker container.
  - The Terraform configuration also includes a script (`user_data.sh`) that pulls the Docker image from ECR and runs the application on the EC2 instance.

### 4. CI/CD Pipeline Setup

- **CI Workflow**:
  - The `ci.yml` GitHub Actions workflow is triggered on every push to the `main` branch.
  - This workflow builds the Docker image, tags it, and pushes it to the Amazon ECR repository specified in your GitHub Secrets.
  - After the Docker image is pushed, a trigger is sent to the CD pipeline to deploy the infrastructure.

- **CD Workflow**:
  - The `terraform.yml` GitHub Actions workflow is triggered either manually via `workflow_dispatch` or automatically by the CI workflow using the `repository_dispatch` event.
  - This workflow initializes Terraform, creates a plan to deploy the resources, and applies the plan to provision the EC2 instance.
  - The EC2 instance will then pull the Docker image from the ECR repository and run it.

## How to Deploy

1. **Push Changes to `main` Branch**:  
   Every time you push a change to the `main` branch, the CI pipeline will automatically:
   - Build and push the Docker image to the ECR repository.
   - Trigger the CD pipeline to deploy the EC2 instance with the Strapi Docker container.

2. **Terraform Deployment**:
   The CD pipeline will:
   - Create or update the EC2 instance using Terraform.
   - Pull the Docker image from the ECR repository.
   - Start the Strapi application on the EC2 instance.

## Folder Structure

```plaintext
strapi-deployment/
├── terraform/                  # Terraform configuration files
│   ├── main.tf                 # Main Terraform configuration
│   ├── variables.tf            # Variables for Terraform
│   ├── outputs.tf              # Output variables
│   └── user_data.sh            # EC2 instance startup script
├── Dockerfile                  # Dockerfile to containerize Strapi app
├── .github/
│   └── workflows/
│       ├── ci.yml              # CI pipeline for building and pushing Docker image
│       └── terraform.yml       # CD pipeline for deploying infrastructure using Terraform
└── strapi/                      # Strapi application source code
```

## Workflow Summary

### CI Workflow
- **Triggered on**: Every push to the `main` branch.
- **Actions**:
  - Builds the Docker image for Strapi.
  - Pushes the image to the ECR repository.
  - Triggers the CD workflow to deploy the infrastructure.

### CD Workflow
- **Triggered by**: The CI workflow or manually via `workflow_dispatch`.
- **Actions**:
  - Initializes and applies the Terraform plan.
  - Provisions an EC2 instance.
  - Pulls and runs the Docker image on the EC2 instance.

## Notes
- Make sure the EC2 instance has the correct IAM permissions to pull from the ECR repository.
- Ensure the EC2 security group allows access to the necessary ports (e.g., HTTP port 80).
- You can monitor the deployment and EC2 instance from the AWS Console.
