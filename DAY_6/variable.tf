variable "ami_id" {
  type = string
  default = "ami-0ac7b260cf76d8865"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "region" {
  type    = string
  default = "ap-south-1"
}


variable "ports" {
  default =[22, 80, 443]
}