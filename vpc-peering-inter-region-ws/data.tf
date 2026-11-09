data "tfe_outputs" "customer_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-network-ws"
}

data "tfe_outputs" "customer_security" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-security-ws"
}

data "tfe_outputs" "account_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "account-network-ws"
}

data "tfe_outputs" "account_security" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "account-security-ws"
}

data "tfe_outputs" "statement_network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "statement-network-ws"
}

data "tfe_outputs" "statement_security" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "statement-security-ws"
}

# Short names for the outputs used by the resources in this workspace.
locals {
  customer_network  = data.tfe_outputs.customer_network.nonsensitive_values
  account_network   = data.tfe_outputs.account_network.nonsensitive_values
  statement_network = data.tfe_outputs.statement_network.nonsensitive_values

  customer_security  = data.tfe_outputs.customer_security.nonsensitive_values
  account_security   = data.tfe_outputs.account_security.nonsensitive_values
  statement_security = data.tfe_outputs.statement_security.nonsensitive_values
}
