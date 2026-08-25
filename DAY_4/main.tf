provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

# Security group to allow SSH access
resource "aws_security_group" "allow_ports" {
  name = "ec2-security-group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "sample_ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.allow_ports.id]
  key_name               = "my_new_ec2_keypair"
}
 