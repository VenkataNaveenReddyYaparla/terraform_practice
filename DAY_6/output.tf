
output "vm_name" {
  description = "The VM instance ID"
  value       = aws_instance.sample_ec2.id
}



output "vm_public_ip" {
  description = "The public IP address of the VM"
  value       = aws_instance.sample_ec2.public_ip
}
