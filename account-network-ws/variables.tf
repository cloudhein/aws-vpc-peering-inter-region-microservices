variable "region" {
  description = "AWS Region for the Account service."
  type        = string
  default     = "ap-southeast-5"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR. Each service VPC must use a different range."
  type        = string
  default     = "172.16.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

variable "private_subnets_cidr" {
  description = "Two private subnet CIDRs inside this VPC."
  type        = list(string)
  default     = ["172.16.101.0/24", "172.16.102.0/24"]

  validation {
    condition     = length(var.private_subnets_cidr) == 2
    error_message = "Provide two private subnet CIDRs."
  }
}

variable "artifacts_bucket" {
  description = "Existing S3 bucket containing the application binaries."
  type        = string
  default     = "account-374549652609-ap-southeast-5-an"
}
