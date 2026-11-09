## network workspaces state file references
data "tfe_outputs" "customer_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-network-ws"
}

data "tfe_outputs" "account_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "account-network-ws"
}

data "tfe_outputs" "statement_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "statement-network-ws"
}

## compute workspaces state file references 
data "tfe_outputs" "customer_compute" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-compute-ws"
}

data "tfe_outputs" "account_compute" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "account-compute-ws"
}

data "tfe_outputs" "statement_compute" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "statement-compute-ws"
}
