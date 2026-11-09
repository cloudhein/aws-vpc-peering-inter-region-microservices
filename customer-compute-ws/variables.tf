variable "region" {
  description = "AWS Region for the Customer Profile service."
  type        = string
  default     = "ap-southeast-1"
}

# variable "aws_account_id" {
#   description = "AWS account that owns the ALB certificate."
#   type        = string
#   default     = "3745496856"
#   validation {
#     condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
#     error_message = "Use a 12-digit AWS account ID."
#   }
# }

variable "certificate_arn" {
  description = "Existing ISSUED ACM certificate in this Region. Internal ALBs must match their service DNS name."
  type        = string
}

variable "ami_id" {
  description = "Optional pinned Ubuntu x86_64 AMI. The image must include curl, ca-certificates, systemd and cloud-init."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Use an x86_64 instance type compatible with the AMD64 artifacts."
  type        = string
  default     = "t3.micro"
}

variable "upstream_url" {
  description = "Upstream private ALB URL. HTTP matches the reference deployment script."
  type        = string
  default     = "http://account.nandaxsr.xyz"
  validation {
    condition     = can(regex("^https?://[a-zA-Z0-9.-]+(:80|:443)?/?$", var.upstream_url))
    error_message = "Use an HTTP or HTTPS origin without paths or shell metacharacters."
  }
}

variable "root_volume_size" {
  description = "Root volume size in GiB. Must be at least 8 GiB for Ubuntu."
  type        = number
  default     = 10
  validation {
    condition     = var.root_volume_size >= 8
    error_message = "Root volume size must be at least 8 GiB."
  }
}

variable "jump_root_volume_size" {
  description = "Root volume size in GiB for the jump host. Must be at least 8 GiB for Ubuntu."
  type        = number
  default     = 8
  validation {
    condition     = var.jump_root_volume_size >= 8
    error_message = "Jump host root volume size must be at least 8 GiB."
  }
}

variable "ssh_public_key_secret_id" {
  description = "AWS Secrets Manager secret ID containing the public SSH key for the app and jump instances."
  type        = string
  default     = "microservices/ssh-public-key"
}