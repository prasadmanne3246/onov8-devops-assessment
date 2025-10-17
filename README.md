\# Onov8 DevOps Assessment — by Jeevan Prasad



\## 🌐 Live URL

http://3.6.92.153:3000/



\## 🧩 Project Overview

This project deploys a Node.js + MongoDB application to AWS ECS using Terraform and GitHub Actions for complete CI/CD automation.



\## ⚙️ Tech Stack

\- AWS ECS (Fargate)

\- ECR (Elastic Container Registry)

\- Terraform (Infrastructure as Code)

\- Docker

\- GitHub Actions (CI/CD)

\- Node.js + Express

\- MongoDB



\## 🚀 CI/CD Workflow

1\. Developer pushes code to GitHub

2\. GitHub Actions builds Docker image \& pushes to ECR

3\. ECS service automatically redeploys new container

4\. App is live on AWS at port 3000



\## Architecture Diagram

&nbsp;                ┌─────────────────────────────┐

&nbsp;                │        GitHub Repo          │

&nbsp;                │  (Node.js App + Terraform)  │

&nbsp;                └─────────────┬───────────────┘

&nbsp;                              │

&nbsp;                              ▼

&nbsp;                  ┌─────────────────────┐

&nbsp;                  │ GitHub Actions CI/CD│

&nbsp;                  │  - Docker Build     │

&nbsp;                  │  - Push to ECR      │

&nbsp;                  │  - Terraform Apply  │

&nbsp;                  └─────────────┬───────┘

&nbsp;                                │

&nbsp;                                ▼

&nbsp;                  ┌─────────────────────────────┐

&nbsp;                  │     AWS Infrastructure      │

&nbsp;                  │  - ECR Repository           │

&nbsp;                  │  - ECS Cluster (Fargate)    │

&nbsp;                  │  - IAM Roles                │

&nbsp;                  │  - VPC, Subnets, SG         │

&nbsp;                  │  - S3 (TF State) + DynamoDB │

&nbsp;                  └─────────────────────────────┘

&nbsp;                                │

&nbsp;                                ▼

&nbsp;                  🌐 Public URL → http://3.111.246.236:3000/





\## 🗂️ Folder structure



onov8-devops-test/

│

├── app/

│   ├── app.js

│   ├── package.json

│   ├── package-lock.json

│   ├── Dockerfile

│   └── .dockerignore

│

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   └── terraform.tfvars

│

├── .github/

│   └── workflows/

│       └── deploy.yml

│

├── README.md

└── folder-structure.txt







\## 🗂️ Repo Structure



onov8-devops-test/

├── app/

├── terraform/

├── .github/workflows/deploy.yml

└── README.md



\## project folder



onov8-devops-test/

│

├── app/                  # Node.js app

│   ├── Dockerfile

│   ├── package.json

│   └── server.js

│

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   ├── backend.tf

│   ├── modules/

│   │   ├── vpc/

│   │   ├── ecs/

│   │   ├── alb/          

│   │   └── ecr/

│

├── comparison.md          # ECS EC2 vs Fargate

└── README.md

\## Alb --

“ALB creation skipped because AWS account doesn’t yet support ELBv2.

ECS task exposed directly via public IP (working at http://3.111.246.236:3000/).”



\## Terraform Project Structure



onov8-devops-test/

├── app/

│   ├── Dockerfile

│   ├── package.json

│   ├── server.js

│   ├── ...

├── terraform/

│   ├── main.tf

│   ├── variables.tf

│   ├── outputs.tf

│   ├── terraform.tfvars

│   ├── backend.tf

│   └── modules/

│       ├── vpc/

│       │   ├── main.tf

│       │   ├── variables.tf

│       │   ├── outputs.tf

│       ├── ecs/

│       │   ├── main.tf

│       │   ├── variables.tf

│       │   ├── outputs.tf

│       ├── ecr/

│       │   ├── main.tf

│       │   ├── variables.tf

│       │   ├── outputs.tf

│       └── iam/

│           ├── main.tf

│           ├── variables.tf

│           ├── outputs.tf



\##

cd D:\\project\\onov8-devops-test

git init

git remote add origin https://github.com/<your-username>/onov8-devops-test.git

git add .

git commit -m "Initial commit - Onov8 DevOps Test"

git push origin main





\## 👨‍💻 Author

\*\*Jeevan Prasad\*\*

Cloud DevOps Engineer

📧 prasadmanne3246@gmail.com

📞 +91-9966309353

