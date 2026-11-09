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
  region = data.tfe_outputs.account_network.nonsensitive_values.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}

provider "aws" {
  alias  = "statement"
  region = data.tfe_outputs.statement_network.nonsensitive_values.region
  default_tags {
    tags = {
      Project   = "vpc-peering-inter-region-microservices"
      ManagedBy = "Terraform"
    }
  }
}
