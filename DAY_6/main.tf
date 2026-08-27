
##############################################
########## LOOP COMPONENT #####
##############################################

provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket         = "my-terraforrm-bucket-for-statefile"
    key            = "day-6/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    # dynamodb_table = "terraform-state-locks"
  }
}


/*
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-state-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}  

*/



# Security group to allow SSH access
resource "aws_security_group" "allow_ports" {
  name = "ec2-security-group"

  dynamic ingress {
   for_each =var.ports
   content{
     from_port=ingress.value
     to_port=ingress.value
     protocol="tcp"
     cidr_blocks=["0.0.0.0/0"]
   }
  }

  }
  
# EC2 instance
resource "aws_instance" "sample_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  key_name               = "my_new_ec2_keypair"
}
 