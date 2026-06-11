# Example variables for deploying the SonarQube instance
# Copy to sonar.auto.tfvars or pass with -var-file

# Required: your existing EC2 key pair name in the target region
key_name = "weiquanlee95"

# Optional customizations (defaults are t3.medium + port 9000 + open to world)
# sonarqube_instance_type = "t3.medium"
# sonarqube_port          = 9000

# Strongly recommended: restrict these in any non-demo environment
# allowed_cidr_blocks = ["YOUR_OFFICE_IP/32", "YOUR_HOME_IP/32"]

# You can also add extra tags
# tags = {
#   Environment = "dev"
#   Owner       = "platform-team"
# }
