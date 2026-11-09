provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}