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

### DAY_3 - EC2 with Data Source

Creates an EC2 instance using a data source to reference an existing default VPC.

**Resources:**
- Data source: Default VPC lookup
- EC2 instance: t3.micro (Amazon Linux 2)
- Security group: SSH access (port 22)
- Outputs: Default VPC ID, VM instance ID, and public IP

**Key concepts:**
- Demonstrates `data` sources to reference existing AWS resources
- Uses variables with proper syntax (no quotes around `var.*`)
- Outputs multiple values

**Usage:**
```powershell
cd DAY_3
terraform init
terraform plan
terraform apply
terraform state list
terraform show
terraform refresh
terraform destroy
```

**terraform state list Output:**
```
data.aws_vpc.default
aws_instance.sample_ec2
aws_security_group.all_ssh
```

**terraform refresh Output:**
Syncs the local Terraform state with actual AWS resources:
```
data.aws_vpc.default: Reading...
aws_security_group.all_ssh: Refreshing state... [id=sg-0538aa9f57025b5b1]
aws_instance.sample_ec2: Refreshing state... [id=i-0bd093c52867b9ae8]
data.aws_vpc.default: Read complete after 0s [id=vpc-0aa6191354ae0a344]

Outputs:
default_vpc_id = "vpc-0aa6191354ae0a344"
vm_name        = "i-0bd093c52867b9ae8"
vm_public_ip   = "3.111.58.82"
```

> **Note:** `terraform refresh` updates the state file without modifying any resources. Useful when resources are changed outside Terraform (AWS Console, CLI, etc.)

**State Output Example:**
```
data.aws_vpc.default         # Default VPC data source
aws_instance.sample_ec2      # EC2 instance resource
aws_security_group.all_ssh   # Security group resource
```

**terraform show Output (Key Fields):**
```hcl
# data.aws_vpc.default:
data "aws_vpc" "default" {
  arn           = "arn:aws:ec2:ap-south-1:611346097057:vpc/vpc-0aa6191354ae0a344"
  cidr_block    = "172.31.0.0/16"
  default       = true
  id            = "vpc-0aa6191354ae0a344"
  instance_tenancy = "default"
}

# aws_instance.sample_ec2:
resource "aws_instance" "sample_ec2" {
  ami                    = "ami-0ac7b260cf76d8865"
  arn                    = "arn:aws:ec2:ap-south-1:611346097057:instance/i-0bd093c52867b9ae8"
  id                     = "i-0bd093c52867b9ae8"
  instance_state         = "running"
  instance_type          = "t3.micro"
  key_name               = "my_new_ec2_keypair"
  private_ip             = "172.31.14.208"
  public_dns             = "ec2-3-111-58-82.ap-south-1.compute.amazonaws.com"
  public_ip              = "3.111.58.82"
  vpc_security_group_ids = ["sg-0538aa9f57025b5b1"]
}

# aws_security_group.all_ssh:
resource "aws_security_group" "all_ssh" {
  arn         = "arn:aws:ec2:ap-south-1:611346097057:security-group/sg-0538aa9f57025b5b1"
  id          = "sg-0538aa9f57025b5b1"
  name        = "ec2-security-group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

Outputs:
default_vpc_id = "vpc-0aa6191354ae0a344"
vm_name        = "i-0bd093c52867b9ae8"
vm_public_ip   = "3.111.58.82"
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

## Terraform Workspaces

A workspace provides a separate Terraform state for the same configuration. The configuration files remain the same, but each workspace tracks different resource instances.

For example, DAY_5 used these workspaces:

```text
default    # The original workspace
dev        # A separate workspace with separate state
```

### Workspace Commands

Run these commands from the project directory:

```powershell
terraform workspace list
terraform workspace show
terraform workspace new dev
terraform workspace select dev
terraform workspace select default
terraform workspace delete dev
```

When a new workspace is created, its state starts empty. Therefore, running `terraform apply` in `dev` creates a new EC2 instance and security group, even if `default` already has resources.

Each workspace must be checked before running commands:

```powershell
terraform workspace select dev
terraform plan
terraform apply
terraform state list
terraform destroy
```

`terraform destroy` affects only the currently selected workspace. Switching to `default` and running `terraform destroy` affects the resources tracked by `default`, not `dev`.

### Important Notes

- A workspace has its own state; resources are not shared between workspaces.
- Workspaces do not create separate folders or separate AWS accounts.
- With an S3 backend, workspace state is stored separately under workspace-specific state paths.
- The S3 bucket and DynamoDB lock table are backend infrastructure and should not be managed or destroyed by the DAY_5 workspace configuration.
- Always run `terraform workspace show` before `plan`, `apply`, or `destroy`.

## State and Ignored Files

Terraform state files and `.terraform/` directory are excluded by `.gitignore`.  
The `.terraform.lock.hcl` file is committed to lock provider versions.

