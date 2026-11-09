# Cross-VPC rules are grouped by the security group they belong to.
# Local ALB-to-app rules are in each service security workspace.
# App rules use the first private subnet; ALB egress covers both private subnets.
# Each rule waits for the corresponding VPC peering connection to be accepted.

# Customer app security group: cross-VPC ingress and egress

# Ingress: allow ICMP echo requests from the Account app.
resource "aws_vpc_security_group_ingress_rule" "customer_ping_from_account" {
  security_group_id = local.customer_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Egress: allow HTTP to the Account ALB on port 80.
resource "aws_vpc_security_group_egress_rule" "customer_http_to_account_alb" {
  count = length(local.account_network.private_subnet_cidrs)

  security_group_id = local.customer_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Egress: allow HTTPS to the Account ALB on port 443.
resource "aws_vpc_security_group_egress_rule" "customer_https_to_account_alb" {
  count = length(local.account_network.private_subnet_cidrs)

  security_group_id = local.customer_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Egress: allow SSH to the Account app on port 22.
resource "aws_vpc_security_group_egress_rule" "customer_ssh_to_account" {
  security_group_id = local.customer_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Egress: allow ICMP echo requests to the Account app.
resource "aws_vpc_security_group_egress_rule" "customer_ping_to_account" {
  security_group_id = local.customer_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}


# Account ALB security group: cross-VPC ingress

# Ingress: accept HTTP only from the Customer app on port 80.
resource "aws_vpc_security_group_ingress_rule" "account_alb_http_from_customer" {
  provider = aws.account

  security_group_id = local.account_security.alb_security_group_id
  cidr_ipv4         = local.customer_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Ingress: accept HTTPS only from the Customer app on port 443.
resource "aws_vpc_security_group_ingress_rule" "account_alb_https_from_customer" {
  provider = aws.account

  security_group_id = local.account_security.alb_security_group_id
  cidr_ipv4         = local.customer_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}


# Account app security group: cross-VPC ingress and egress

# Ingress: allow SSH from the Customer app on port 22.
resource "aws_vpc_security_group_ingress_rule" "account_ssh_from_customer" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.customer_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Ingress: allow ICMP echo requests from the Customer app.
resource "aws_vpc_security_group_ingress_rule" "account_ping_from_customer" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.customer_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Ingress: allow ICMP echo requests from the Statement app.
resource "aws_vpc_security_group_ingress_rule" "account_ping_from_statement" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.statement_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Egress: allow HTTP to the Statement ALB on port 80.
resource "aws_vpc_security_group_egress_rule" "account_http_to_statement_alb" {
  provider = aws.account

  count = length(local.statement_network.private_subnet_cidrs)

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.statement_network.private_subnet_cidrs[count.index]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Egress: allow HTTPS to the Statement ALB on port 443.
resource "aws_vpc_security_group_egress_rule" "account_https_to_statement_alb" {
  provider = aws.account

  count = length(local.statement_network.private_subnet_cidrs)

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.statement_network.private_subnet_cidrs[count.index]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Egress: allow SSH to the Statement app on port 22.
resource "aws_vpc_security_group_egress_rule" "account_ssh_to_statement" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.statement_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Egress: allow ICMP echo requests to the Customer app.
resource "aws_vpc_security_group_egress_rule" "account_ping_to_customer" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.customer_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.customer_account]
}

# Egress: allow ICMP echo requests to the Statement app.
resource "aws_vpc_security_group_egress_rule" "account_ping_to_statement" {
  provider = aws.account

  security_group_id = local.account_security.app_security_group_id
  cidr_ipv4         = local.statement_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}


# Statement ALB security group: cross-VPC ingress

# Ingress: accept HTTP only from the Account app on port 80.
resource "aws_vpc_security_group_ingress_rule" "statement_alb_http_from_account" {
  provider = aws.statement

  security_group_id = local.statement_security.alb_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Ingress: accept HTTPS only from the Account app on port 443.
resource "aws_vpc_security_group_ingress_rule" "statement_alb_https_from_account" {
  provider = aws.statement

  security_group_id = local.statement_security.alb_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}


# Statement app security group: cross-VPC ingress and egress

# Ingress: allow SSH from the Account app on port 22.
resource "aws_vpc_security_group_ingress_rule" "statement_ssh_from_account" {
  provider = aws.statement

  security_group_id = local.statement_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Ingress: allow ICMP echo requests from the Account app.
resource "aws_vpc_security_group_ingress_rule" "statement_ping_from_account" {
  provider = aws.statement

  security_group_id = local.statement_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}

# Egress: allow ICMP echo requests to the Account app.
resource "aws_vpc_security_group_egress_rule" "statement_ping_to_account" {
  provider = aws.statement

  security_group_id = local.statement_security.app_security_group_id
  cidr_ipv4         = local.account_network.private_subnet_cidrs[0]
  ip_protocol       = "icmp"
  from_port         = 8
  to_port           = 0

  depends_on = [aws_vpc_peering_connection_accepter.account_statement]
}
