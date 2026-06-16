variable "name" {
  description = "Name prefix for resources"
  type        = string
  default     = "gha-java-app"
}

variable "subnet_newbits" {
  description = "Number of new bits to add to VPC CIDR to generate subnets (e.g., 8 means /24 from /16)"
  type        = number
  default     = 8
}

variable "environment_name" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# --- SonarQube instance variables ---
data "aws_availability_zones" "available" {
  state = "available"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair to use for SSH access to the SonarQube instance (required)"
  type        = string
  default = "weiquanlee95"
}

variable "sonarqube_instance_type" {
  description = "EC2 instance type for SonarQube"
  type        = string
  default     = "t3.medium"
}

variable "sonarqube_port" {
  description = "Port to expose for SonarQube web UI"
  type        = number
  default     = 9000
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to reach port 9000 and SSH. Defaults to world-open as requested (restrict in real environments)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

locals {
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k)]
  private_subnets = [for k, az in local.azs : cidrsubnet(var.vpc_cidr, var.subnet_newbits, k + 10)]
}