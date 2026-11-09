data "tfe_outputs" "network" {
  organization = "vpc-peering-inter-region-microservices"
  workspace    = "customer-network-ws"
}

locals {
  network = data.tfe_outputs.network.nonsensitive_values
}
