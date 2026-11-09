provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "account"
  region = local.account_network.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "statement"
  region = local.statement_network.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}
