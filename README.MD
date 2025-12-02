# AWS Deployment Guide

## Overview

PACAT is a Retrieval-Augmented Generation (RAG) platform that allows you to create and manage AI "agents" and chat with them. The application consists of two main components:

- **Frontend**: React-based web interface ([GitHub Repository](https://github.com/CLOUDLAB-URV/aina-frontend))
- **Backend**: Python API service ([GitHub Repository](https://github.com/CLOUDLAB-URV/aina-backend))

### Architecture

- **Frontend**: Deployed on AWS Amplify.
- **Backend**: Deployed on an EC2 instance running Docker.
- **Infrastructure**: Managed with Terraform
- **Custom AMI**: Built with HashiCorp Packer, includes Docker pre-installed.

---

## Docker Deployment Guide

If you prefer to deploy the RAG platform using Docker for local development or testing, please refer to the [Docker Deployment Guide](DOCKER.MD).

---

## Prerequisites

Before deploying the application, ensure you have the following tools installed and configured:

### 1. Install Required Tools

#### Terraform
Install Terraform for infrastructure as code management:
- [**Installation Guide**](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- **Verify installation**: 
  ```bash
  terraform --version
  ```

#### Packer
Install Packer for building custom AMIs:
- **Installation Guide**: [https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli](https://developer.hashicorp.com/packer/tutorials/aws-get-started/get-started-install-cli)
- **Verify installation**:
  ```bash
  packer --version
  ```

#### AWS CLI
Install and configure the AWS CLI:
- [**Installation Guide**](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [**Configuration Guide**](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

#### Configure AWS Credentials
After installing AWS CLI, configure it with your AWS credentials:

```bash
aws configure
```

You'll need to provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-1`)
- Default output format (e.g., `json`)

**Verify AWS authentication**:
```bash
aws sts get-caller-identity
```

---

## Deployment Steps

### Step 1: Fork the Frontend Repository

1. Navigate to the frontend repository: [https://github.com/CLOUDLAB-URV/aina-frontend](https://github.com/CLOUDLAB-URV/aina-frontend)
2. Click the **Fork** button in the top-right corner
3. Select your GitHub account as the destination
4. Wait for the fork to complete

### Step 2: Create a GitHub Personal Access Token

AWS Amplify needs a GitHub personal access token to authenticate and access your forked repository.

1. Follow the official AWS guide to create a token: [Setting up GitHub access for AWS Amplify](https://docs.aws.amazon.com/amplify/latest/userguide/setting-up-GitHub-access.html#setting-up-github-app-cloudformation)
2. **Quick Steps**:
   - Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Click "Generate new token (classic)"
   - Give it a descriptive name (e.g., "AWS Amplify AINA")
   - Select the following scopes:
     - `repo` (Full control of private repositories)
     - `admin:repo_hook` (Full control of repository hooks)
   - Click "Generate token"
   - **Important**: Copy the token immediately - you won't be able to see it again!

### Step 3: Update Terraform Configuration

1. Open the `terraform.tfvars` file in this directory
2. Update the `repository_url` to point to your forked repository:
   ```hcl
   repository_url = "https://github.com/YOUR-GITHUB-USERNAME/aina-frontend.git"
   ```

### Step 4: Initialize and Apply Terraform

1. Navigate to the terraform directory:
   ```bash
   cd terraform
   ```

2. Initialize Terraform (downloads required providers and modules):
   ```bash
   terraform init
   ```

3. (Optional) Preview the infrastructure changes:
   ```bash
   terraform plan
   ```

4. Apply the Terraform configuration to create the infrastructure:
   ```bash
   terraform apply
   ```

5. Terraform will prompt you for the following variables:
   - **`access_token`**: The GitHub personal access token you created in Step 2
   - **`admin_password`**: Password for the admin user
   - **`agent_creator_password`**: Password for the agent creator user
   - **`chatuser_password`**: Password for the chat user

6. Review the planned changes and type `yes` to confirm

7. Wait for Terraform to complete (this may take several minutes)

8. **Save the outputs**: Terraform will display important information like:
   - EC2 instance public IP
   - Amplify app URL

### Step 5: Deploy the Frontend

The frontend needs to be manually deployed for the first time:

1. **Navigate to AWS Amplify Console**:
   - Open the AWS Console: [https://console.aws.amazon.com/amplify/](https://console.aws.amazon.com/amplify/)
   - Make sure you're in the correct region (default: `us-east-1`)

2. **Find Your App**:
   - Click on the newly created app named **`aina-frontend`**

3. **Deploy the Main Branch**:
   - In the app dashboard, you'll see the **`main`** branch listed
   - Click on the **`main`** branch
   - Click the **"Run job"** button to start the deployment

4. **Monitor the Deployment**:
   - Watch the build progress through the following stages:
     - Provision
     - Build
     - Deploy
     - Verify
   - The entire process typically takes several minutes

5. **Verify Deployment**:
   - Once completed, the status should show "Deployed"
   - The Amplify app URL will be displayed (format: `https://main.xxxxx.amplifyapp.com`)

### Step 6: Access the Application

1. **Get the Frontend URL**:
   - You can find it in the Terraform outputs as `amplify_app_url`
   - Or copy it from the Amplify Console

2. **Open the Web Application**:
   - Click on **"Visit deployed URL"** in the Amplify Console
   - Or navigate directly to the URL in your browser

3. **Login**:
   Use one of the following usernames with the passwords you set during deployment:
   - **Username**: `admin` (full administrative access)
   - **Username**: `agentcreator` (can create and manage agents)
   - **Username**: `chatuser` (can chat with agents)

---

## Post-Deployment

### Accessing the Backend

The backend is automatically deployed on the EC2 instance. You can find the public IP in the Terraform outputs:

```bash
terraform output spot_instance_public_ip
```

The backend API is accessible at: `http://<EC2_PUBLIC_IP>:8000`

### SSH Access to EC2 Instance

If you configured an SSH key in the `terraform.tfvars` file, you can SSH into the instance:

```bash
ssh -i /path/to/your/key.pem ubuntu@<EC2_PUBLIC_IP>
```

## Cleaning Up

To destroy all resources and avoid ongoing AWS charges:

```bash
terraform destroy
```

Type `yes` when prompted to confirm.

**Note**: This will permanently delete all resources including the EC2 instance, VPC, and Amplify app.

---

## Troubleshooting

### Terraform Apply Fails

- Verify AWS credentials are correctly configured: `aws sts get-caller-identity`
- Check you have sufficient AWS permissions
- Ensure your AWS region supports the instance type (default: `c8i.xlarge`)

### Amplify Deployment Fails

- Verify the GitHub personal access token has the correct permissions
- Check that the repository URL in `terraform.tfvars` is correct
- Ensure the repository is accessible (public or token has access)

### Cannot Access the Application

- Check security groups allow inbound traffic on required ports
- Verify the EC2 instance is running: `aws ec2 describe-instances`
- Check Amplify deployment status in the AWS Console

### Backend Container Not Running

SSH into the EC2 instance and check Docker status:
```bash
ssh ubuntu@<EC2_PUBLIC_IP>
sudo docker ps
sudo docker logs <container_id>
```

---

## Architecture Details

### Network Configuration
- VPC CIDR: `10.0.0.0/16` (configurable)
- Public subnet with Internet Gateway
- Security groups for controlled access

### EC2 Instance
- Instance type: `c8i.xlarge` (configurable)
- Custom Ubuntu 24.04 AMI with Docker pre-installed
- Automatic Docker container startup via user data
