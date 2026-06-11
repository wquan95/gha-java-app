# SonarQube EC2 instance (t3.medium) with inbound access on port 9000
# This file extends the existing VPC defined in main.tf

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security group allowing SonarQube (9000) and SSH (22)
resource "aws_security_group" "sonarqube" {
  name        = "${var.name}-sonarqube-sg"
  description = "Allow inbound access for SonarQube on port 9000 and SSH"
  vpc_id      = aws_vpc.this.id

  # SonarQube web UI
  ingress {
    description = "SonarQube"
    from_port   = var.sonarqube_port
    to_port     = var.sonarqube_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # SSH access (recommended for instance management)
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-sonarqube-sg"
  })
}

# EC2 instance for running SonarQube
resource "aws_instance" "sonarqube" {
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = var.sonarqube_instance_type
  subnet_id              = aws_subnet.public[0].id
  vpc_security_group_ids = [aws_security_group.sonarqube.id]

  associate_public_ip_address = true
  key_name                    = var.key_name

  root_block_device {
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }

  # Basic bootstrap to install Docker and run official SonarQube container.
  # Note: The embedded H2 database in the official image is for evaluation only.
  # For production use an external PostgreSQL database.
  # t3.medium (4 GiB) meets the minimum recommended memory for SonarQube.
  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update and install Docker (Amazon Linux 2023)
              dnf update -y
              dnf install -y docker

              # Start and enable Docker
              systemctl enable --now docker

              # Run SonarQube (community edition via latest tag is fine for demo)
              docker run -d \
                --name sonarqube \
                -p ${var.sonarqube_port}:${var.sonarqube_port} \
                --restart unless-stopped \
                sonarqube:latest

              # Optional: print status
              docker ps
              EOF

  tags = merge(var.tags, {
    Name = "${var.name}-sonarqube"
  })

  depends_on = [aws_internet_gateway.this]
}

# Optional: Elastic IP for a stable public address (commented out by default)
# resource "aws_eip" "sonarqube" {
#   instance = aws_instance.sonarqube.id
#   domain   = "vpc"
#   tags = merge(var.tags, {
#     Name = "${var.name}-sonarqube-eip"
#   })
# }
