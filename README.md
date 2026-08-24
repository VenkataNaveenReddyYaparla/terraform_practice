# Terraform Learning

A Terraform project demonstrating infrastructure-as-code concepts with S3 and EC2 resources.

## Project Structure

### DAY_1 - S3 Bucket

Creates an Amazon S3 bucket with versioning enabled.

**Resources:**
- S3 bucket: `my-terraform-practice-bucket-1534323`
- S3 bucket versioning: enabled
- Output: bucket name

**Usage:**
```powershell
cd DAY_1
terraform init
terraform plan
terraform apply
terraform output bucket_name
terraform destroy
```

### DAY_2 - EC2 Instance

Creates an EC2 instance in a VPC with SSH access.

**Resources:**
- EC2 instance: t3.micro (Amazon Linux 2)
- Security group: SSH access (port 22)
- Outputs: VM instance ID and public IP

**Key concepts:**
- Uses `variable.tf` to define variables
- Uses `terraform.tfvars` to provide variable values
- Demonstrates variable referencing (without quotes: `var.region`)

**Usage:**
```powershell
cd DAY_2
terraform init
terraform plan
terraform apply
terraform output vm_name
terraform output vm_public_ip
terraform destroy
```

## Prerequisites

- Terraform 1.0+ installed
- AWS CLI configured with credentials and region
- EC2 key pair created in your AWS account (`my_new_ec2_keypair`)

## Variables Concept

Terraform uses two files to manage input values:

### variable.tf - Variable Declarations

Defines what variables exist, their types, descriptions, and default values.

```hcl
variable "region" {
  type        = string
  description = "AWS region where resources will be deployed"
  default     = "ap-south-1"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}
```

**Key points:**
- `type` — restricts the value type (string, number, list, map, etc.)
- `description` — documents the variable's purpose
- `default` — optional default value if not provided
- Defines the **schema** of allowed input variables

### terraform.tfvars - Variable Values

Provides actual values for variables declared in `variable.tf`.

```hcl
region        = "ap-south-1"
instance_type = "t3.micro"
ami_id        = "ami-0ac7b260cf76d8865"
```

**Key points:**
- Automatically loaded by Terraform (no need to specify `-var-file`)
- Overrides default values from `variable.tf`
- Should be excluded from version control for sensitive data (use `.gitignore`)

### Using Variables in Code

Reference variables **without quotes**:

```hcl
provider "aws" {
  region = var.region  # Correct - references the variable value
}

resource "aws_instance" "sample_ec2" {
  instance_type = var.instance_type  # Correct
  # instance_type = "var.instance_type"  # WRONG - treats it as text
}
```

### Multiple Environments

Use different `.tfvars` files for different environments:

```powershell
# Development
terraform plan -var-file="dev.tfvars"

# Production
terraform plan -var-file="prod.tfvars"
```

File contents:
- `dev.tfvars`: instance_type = "t2.micro" (cheaper)
- `prod.tfvars`: instance_type = "t3.large" (more powerful)

### Overriding from Command Line

```powershell
terraform plan -var="region=eu-west-1"
terraform plan -var="instance_type=t3.small"
```

### Priority Order (highest to lowest)

1. Command-line: `-var="key=value"`
2. Environment variables: `TF_VAR_region=ap-south-1`
3. `.tfvars` files (auto-loaded: `terraform.tfvars`, `*.auto.tfvars`)
4. Default values in `variable.tf`

## State and Ignored Files

Terraform state files and `.terraform/` directory are excluded by `.gitignore`.  
The `.terraform.lock.hcl` file is committed to lock provider versions.

