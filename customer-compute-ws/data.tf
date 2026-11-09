data "tfe_outputs" "network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-network-ws"
}

data "tfe_outputs" "security" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-security-ws"
}

locals {
  network  = data.tfe_outputs.network.nonsensitive_values
  security = data.tfe_outputs.security.nonsensitive_values
}
# Canonical Ubuntu 24.04 LTS, matching the reference project.
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}
