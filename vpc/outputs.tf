output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value       = [for s in aws_subnet.public : s.id]
  description = "List of public subnet IDs"
}

output "route_table_id" {
  value = aws_route_table.public.id
}

output "private_subnet_ids" {
  value       = [for s in aws_subnet.private : s.id]
  description = "List of private subnet IDs"
}

# --- SonarQube outputs ---

output "sonarqube_instance_id" {
  description = "ID of the SonarQube EC2 instance"
  value       = aws_instance.sonarqube.id
}

output "sonarqube_public_ip" {
  description = "Public IP address of the SonarQube instance"
  value       = aws_instance.sonarqube.public_ip
}

output "sonarqube_public_dns" {
  description = "Public DNS name of the SonarQube instance"
  value       = aws_instance.sonarqube.public_dns
}

output "sonarqube_url" {
  description = "URL to access SonarQube web UI (may take 1-2 minutes after instance launch for container to be ready)"
  value       = "http://${aws_instance.sonarqube.public_ip}:${var.sonarqube_port}"
}

output "sonarqube_security_group_id" {
  description = "Security group ID attached to the SonarQube instance"
  value       = aws_security_group.sonarqube.id
}