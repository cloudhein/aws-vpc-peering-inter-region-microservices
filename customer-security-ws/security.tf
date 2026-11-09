# Rules are grouped by the security group they belong to.
# Cross-VPC rules remain in vpc-peering-inter-region-ws/security.tf.
# All rules are standalone; no allow-all egress rule is added.

# Customer ALB security group and its ingress/egress rules

# Create the Customer ALB security group.
resource "aws_security_group" "alb" {
  name        = "microservices-customer-alb"
  description = "customer ALB: only approved clients and app targets"
  vpc_id      = local.network.vpc_id
}

# Ingress: allow public HTTP on port 80 for the HTTPS redirect.
resource "aws_vpc_security_group_ingress_rule" "public_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
}

# Ingress: allow public HTTPS requests on port 443.
resource "aws_vpc_security_group_ingress_rule" "public_https" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
}

# Egress: send requests and health checks to the Customer app on port 9090.
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
}


# Customer app security group and its ingress/egress rules

# Create the Customer application security group.
resource "aws_security_group" "app" {
  name        = "microservices-customer-app"
  description = "customer application: least privilege"
  vpc_id      = local.network.vpc_id
}

# Ingress: accept requests and health checks from the Customer ALB on port 9090.
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
  description                  = "Application requests and health checks"
}

# Ingress: allow SSH from the jump host on port 22.
resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_jump" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.jump.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

# Ingress: allow ICMP echo requests from the jump host.
resource "aws_vpc_security_group_ingress_rule" "app_ping_from_jump" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.jump.id
  ip_protocol                  = "icmp"
  from_port                    = 8
  to_port                      = 0
}

# Egress: download this service binary from S3 over HTTPS on port 443.
resource "aws_vpc_security_group_egress_rule" "app_to_s3" {
  security_group_id = aws_security_group.app.id
  prefix_list_id    = local.network.s3_prefix_list_id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  description       = "Artifact download over the local S3 gateway endpoint"
}

# Egress: allow ICMP echo requests to the jump host.
# resource "aws_vpc_security_group_egress_rule" "app_ping_to_jump" {
#   security_group_id            = aws_security_group.app.id
#   referenced_security_group_id = aws_security_group.jump.id
#   ip_protocol                  = "icmp"
#   from_port                    = 8
#   to_port                      = 0
# }


# Jump host security group and its ingress/egress rules

# Create the public jump host security group.
resource "aws_security_group" "jump" {
  name        = "microservices-customer-jump"
  description = "One administrator to customer instance only"
  vpc_id      = local.network.vpc_id
}

# Ingress: allow SSH only from the configured administrator IP on port 22.
resource "aws_vpc_security_group_ingress_rule" "jump_admin" {
  security_group_id = aws_security_group.jump.id
  cidr_ipv4         = var.admin_ipv4_cidr
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Ingress: allow ICMP echo requests from the Customer app.
# resource "aws_vpc_security_group_ingress_rule" "jump_ping_from_app" {
#   security_group_id            = aws_security_group.jump.id
#   referenced_security_group_id = aws_security_group.app.id
#   ip_protocol                  = "icmp"
#   from_port                    = 8
#   to_port                      = 0
# }

# Egress: allow SSH to the Customer app on port 22.
resource "aws_vpc_security_group_egress_rule" "jump_ssh_to_app" {
  security_group_id            = aws_security_group.jump.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 22
  to_port                      = 22
}

# Egress: allow ICMP echo requests to the Customer app.
resource "aws_vpc_security_group_egress_rule" "jump_ping_to_app" {
  security_group_id            = aws_security_group.jump.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "icmp"
  from_port                    = 8
  to_port                      = 0
}