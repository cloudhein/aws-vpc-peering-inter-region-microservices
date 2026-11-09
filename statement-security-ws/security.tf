# Rules are grouped by the security group they belong to.
# Cross-VPC rules remain in vpc-peering-inter-region-ws/security.tf.
# All rules are standalone; no allow-all egress rule is added.

# Statement ALB security group and its ingress/egress rules

# Create the Statement ALB security group.
resource "aws_security_group" "alb" {
  name        = "microservices-statement-alb"
  description = "statement ALB: only approved clients and app targets"
  vpc_id      = local.network.vpc_id
}

# Egress: send requests and health checks to the Statement app on port 9090.
resource "aws_vpc_security_group_egress_rule" "alb_to_app" {
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.app.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
}


# Statement app security group and its ingress/egress rules

# Create the Statement application security group.
resource "aws_security_group" "app" {
  name        = "microservices-statement-app"
  description = "statement application: least privilege"
  vpc_id      = local.network.vpc_id
}

# Ingress: accept requests and health checks from the Statement ALB on port 9090.
resource "aws_vpc_security_group_ingress_rule" "app_from_alb" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "tcp"
  from_port                    = 9090
  to_port                      = 9090
  description                  = "Application requests and health checks"
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
