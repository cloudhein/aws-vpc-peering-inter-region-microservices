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
