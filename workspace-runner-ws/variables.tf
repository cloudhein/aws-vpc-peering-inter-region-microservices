variable "organization" {
  description = "HCP Terraform organization containing the existing target workspaces. If changed, also update versions.tf."
  type        = string
  default     = "vpc-peering-inter-region-microservices"
}

variable "workspace_names" {
  description = "Existing HCP workspace names. These do not have to match local folder names."
  type = object({
    customer_network   = string
    account_network    = string
    statement_network  = string
    artifact_policy    = string
    customer_security  = string
    account_security   = string
    statement_security = string
    customer_compute   = string
    account_compute    = string
    statement_compute  = string
    private_dns        = string
    peering            = string
  })

  default = {
    customer_network   = "customer-network-ws"
    account_network    = "account-network-ws"
    statement_network  = "statement-network-ws"
    artifact_policy    = "artifact-bucket-policy-ws"
    customer_security  = "customer-security-ws"
    account_security   = "account-security-ws"
    statement_security = "statement-security-ws"
    customer_compute   = "customer-compute-ws"
    account_compute    = "account-compute-ws"
    statement_compute  = "statement-compute-ws"
    private_dns        = "private-dns-ws"
    peering            = "vpc-peering-inter-region-ws"
  }
}
