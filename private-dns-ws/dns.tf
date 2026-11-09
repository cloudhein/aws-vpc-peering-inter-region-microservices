resource "aws_route53_zone" "services" {
  name    = "nandaxsr.xyz"
  comment = "Private service discovery across the three service VPCs"

  vpc {
    vpc_id     = data.tfe_outputs.customer_network.nonsensitive_values.vpc_id
    vpc_region = data.tfe_outputs.customer_network.nonsensitive_values.region
  }

  vpc {
    vpc_id     = data.tfe_outputs.account_network.nonsensitive_values.vpc_id
    vpc_region = data.tfe_outputs.account_network.nonsensitive_values.region
  }

  vpc {
    vpc_id     = data.tfe_outputs.statement_network.nonsensitive_values.vpc_id
    vpc_region = data.tfe_outputs.statement_network.nonsensitive_values.region
  }

  lifecycle {
    precondition {
      condition     = data.tfe_outputs.customer_compute.nonsensitive_values.https_listener_arn != ""
      error_message = "Apply all three compute workspaces before private DNS."
    }
  }
}

# Account service discovery points at its internal ALB.

resource "aws_route53_record" "account" {
  zone_id = aws_route53_zone.services.zone_id
  name    = "account.nandaxsr.xyz"
  type    = "A"

  alias {
    name                   = data.tfe_outputs.account_compute.nonsensitive_values.alb_dns_name
    zone_id                = data.tfe_outputs.account_compute.nonsensitive_values.alb_zone_id
    evaluate_target_health = true
  }
}

# Statement service discovery points at its internal ALB.

resource "aws_route53_record" "statement" {
  zone_id = aws_route53_zone.services.zone_id
  name    = "statement.nandaxsr.xyz"
  type    = "A"

  alias {
    name                   = data.tfe_outputs.statement_compute.nonsensitive_values.alb_dns_name
    zone_id                = data.tfe_outputs.statement_compute.nonsensitive_values.alb_zone_id
    evaluate_target_health = true
  }
}
