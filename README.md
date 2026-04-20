# Google Cloud Infrastructure

This repository contains the Terraform configuration to provision and manage the Google Cloud Platform (GCP) infrastructure for demo/sandbox purposes.



## Overview

The project uses a modular Terraform structure to ensure reusability and consistency across different environments (Development, Production, etc.). It automates the deployment of a secure, scalable architecture including VPC networking, managed databases, and serverless application hosting.

## Architecture Components

- **Networking**: VPC and Subnets configured for secure communication.
- **IAM & Security**: Managed Service Accounts and Cloud KMS for encryption at rest.
- **Cloud SQL**: Managed PostgreSQL instance with private IP and KMS encryption.
- **Cloud Run**: Serverless application hosting with VPC connectivity and database integration.

## Project Structure

```text
.
├── environments/          # Environment-specific configurations
│   ├── dev/               # Development environment
│   └── prod/              # Production environment (Placeholder)
├── modules/               # Reusable Terraform modules
│   ├── cloud-run/         # App hosting module
│   ├── cloud-sql/         # Database module
│   ├── iam-security/      # IAM and KMS module
│   └── networking/        # VPC and subnet module
├── variables.tf           # Global variables
├── versions.tf            # Terraform and provider versions
└── provider.tf            # GCP provider configuration
```

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0.0)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- A GCP Project with billing enabled.

## Getting Started

### 1. Configure Authentication

Ensure you are authenticated with Google Cloud:

```bash
gcloud auth application-default login
```

### 2. Set Up Backend

Copy `backend.tf.example` to `backend.tf` in the desired environment directory and configure your GCS bucket for state storage.

```bash
cp backend.tf.example environments/dev/backend.tf
```

### 3. Provide Variables

Create a `terraform.tfvars` file in the environment directory (e.g., `environments/dev/terraform.tfvars`) to provide required values:

```hcl
project_id = "your-gcp-project-id"
region     = "asia-southeast1"
```

*Note: `*.tfvars` files are ignored by git to prevent accidental exposure of sensitive information.*

### 4. Initialize and Apply

Navigate to the environment directory and run the following commands:

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Maintenance

- **Adding Modules**: Place new reusable components in the `modules/` directory.
- **New Environments**: Create a new subdirectory in `environments/` and reference the existing modules.
