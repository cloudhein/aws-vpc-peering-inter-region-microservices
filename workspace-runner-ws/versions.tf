terraform {
  required_version = "~>1.17.0"

  # Set this HCP workspace's execution mode to Local before running the controller.
  # HCP stores the controller state; your computer runs the TFE API calls.
  cloud {
    organization = "vpc-peering-inter-region-microservices"

    workspaces {
      name = "workspace-runner-ws"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.83.0"
    }
  }
}
