# Output the public IP of the Docker server
output "instance_public_ip" {
  description = "Public IP address of the Docker EC2 instance"
  value       = aws_instance.docker_server.public_ip
}

# Output the public DNS of the Docker server
output "instance_public_dns" {
  description = "Public DNS of the Docker EC2 instance"
  value       = aws_instance.docker_server.public_dns
}

# Output the VPC ID
output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

# Output the Subnet ID
output "subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

# Output the Security Group ID
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.docker_sg.id
}
