variable "region" {
  description = "AWS Region for the Customer Profile service."
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR. Each service VPC must use a different range."
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

variable "public_subnets_cidr" {
  description = "Two public subnet CIDRs for the Customer ALB and jump host."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnets_cidr) >= 2
    error_message = "Provide at least two public subnet CIDRs."
  }
}

variable "private_subnets_cidr" {
  description = "Two private subnet CIDRs inside this VPC."
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]

  validation {
    condition     = length(var.private_subnets_cidr) >= 2
    error_message = "Provide at least two private subnet CIDRs."
  }
}

variable "artifacts_bucket" {
  description = "Existing S3 bucket containing the application binaries."
  type        = string
  default     = "customer-374549652609-ap-southeast-1-an"
}
