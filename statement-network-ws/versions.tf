terraform {
  required_version = ">= 1.11.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.69.1"
    }
  }
  cloud {
    organization = "vpc-peering-inter-region-microservices"
    workspaces {
      name = "statement-network-ws"
    }
  }
}
