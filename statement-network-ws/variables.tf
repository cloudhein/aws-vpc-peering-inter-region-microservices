variable "region" {
  description = "AWS Region for the Statement service."
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR. Each service VPC must use a different range."
  type        = string
  default     = "192.168.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

variable "private_subnets_cidr" {
  description = "Two private subnet CIDRs inside this VPC."
  type        = list(string)
  default     = ["192.168.101.0/24", "192.168.102.0/24"]

  validation {
    condition     = length(var.private_subnets_cidr) == 2
    error_message = "Provide two private subnet CIDRs."
  }
}

variable "artifacts_bucket" {
  description = "Existing S3 bucket containing the application binaries."
  type        = string
  default     = "statement-374549652609-ap-northeast-1-an"
}
