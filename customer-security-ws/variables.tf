variable "region" {
  description = "AWS Region for the Customer Profile service."
  type        = string
  default     = "ap-southeast-1"
}

variable "admin_ipv4_cidr" {
  description = "Only this public IPv4 /32 can SSH to the jump host."
  type        = string
  default     = "27.130.180.5/32"
  validation {
    condition     = can(cidrnetmask(var.admin_ipv4_cidr)) && endswith(var.admin_ipv4_cidr, "/32")
    error_message = "Supply exactly one IPv4 address in /32 notation."
  }
}
