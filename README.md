# URL Shortner ECS Fargate

A high-availability, microservices-based URL shortener application containerised and deployed via AWS ECS Fargate within a multi-AZ VPC. With CI/CD via github actions. ingress traffic is managed via an ALB with WAF rules configured for con trolled access and security.Infrastructure provisioning and deployment pipelines are fully automated using Terraform and GitHub Actions.

## Overview
* **AWS ECS Fargate**: Serverless, scalable compute option to host and run the application
* **Networking:** Custom VPC, Private/Public Subnets, Routes, Security Groups, ALB
* **AWS WAF**: Filtering web requests for enhanced security
* **VPC Endpoints**: Cost-efficient option to provide private access to AWS resources. Eliminating use of expensive NAT Gateways
* **PostgreSQL (RDS)**: Stores click analytics
* **TLS/DNS**: SSL Certification configured via ACM, DNS (Cloudflare), fully automated
* **Github Actions**: CI/CD pipelines to containerise application and deploy Terraform provisioned infrastructure. OIDC enabled. 
* **Infrastructure as Code (IaC):** Terraform manages all infrastructure, fully automated


## Demo 

> **Note:** The video demonstrates the full AWS ECS Fargate infrastructure deployment process and application functionality.

## Architecture


## Design Decisions



## Project Architecture 


## Infrastructure
**Custom VPC:** Consisting of 2 public subnets and 2 Private subnets across 2 AZ's. Ensuring high availability.

**Internet Gateway:** Internet gateway enabling bidirectional traffic, with NAT Gateway providing secure outbound access for private subnets.

**Route53:** Provides DNS Resolution for domain `(lnk.shahankhan.co.uk)` to ALB via Alias record. 

**ACM & Cloudflare Integration:** Automates TLS certificate issuance and validation by managing DNS records via the Cloudflare API.

**Application Load Balancer:** Handles SSL/TLS termination, enforces HTTP-to-HTTPS redirection,routes traffic across multi-AZ public subnets. Integrated with **AWS WAF** to inspect payloads and mitigate common web exploits and malicious bot traffic.

**ECS/Fargate:** Serverless container orchestration. Provisoned across multiple AZ's ensuring high avialability.

**S3 Bucket:** `.tfstate` is stored in secure S3 bucket with native locking enabled. Ensuring idempotency and and prevent concurrent modification by multiple users or processes.


## Local Setup (Quick start)

**Prerequisites:** Docker


You can run a health check via:
`curl http://localhost:8080/healthz`


## Setup Order & Prerequisites
Before running the automated deployment pipelines, the S3 bucket for .tfstate file must be provisioned and GitHub authentication paths must be provisioned manually.

### 1. Bootstrap the S3 Backend (`backend-bootstrap/`)
```bash
cd backend-boostrap/
terraform init
terraform apply -auto-approve
```

This will generate the S3 bucket required to store your .tfstate file. Enabling versioning. 

### 2. Configure GitHub Secrets

| Secret Name | Description | Example / Format |
| :--- | :--- | :--- |
| `AWS_ACCOUNT_ID` | Your AWS Account ID, this is used to for the github actions IAM Role to authenticate the CLI via OIDC | `arn:aws:iam::123456789012:role/github-actions-role` |



## Security profile and decisions 


## CI/CD Pipelines