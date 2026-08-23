# Terraform Learning

A simple Terraform project that creates an Amazon S3 bucket in the Asia Pacific (Mumbai) region.

## Resources

- S3 bucket: `my-terraform-practice-bucket-1534323`
- S3 bucket versioning: enabled
- Terraform output: bucket name

## Prerequisites

- Terraform installed
- AWS CLI configured with permission to create S3 buckets

## Usage

Run these commands from the `DAY_1` directory:

```powershell
cd DAY_1
terraform init
terraform plan
terraform apply
```

To display the bucket name:

```powershell
terraform output bucket_name
```

To remove the resources:

```powershell
terraform destroy
```

## State and ignored files

Terraform state files and the `.terraform` directory are excluded by `.gitignore`. The `.terraform.lock.hcl` file is committed so Terraform uses the same provider version consistently.
