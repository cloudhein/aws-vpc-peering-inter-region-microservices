# Customer VPC <-> Account VPC

resource "aws_vpc_peering_connection" "customer_account" {
  vpc_id      = local.customer_network.vpc_id
  peer_vpc_id = local.account_network.vpc_id
  peer_region = local.account_network.region
  auto_accept = false

  tags = {
    Name = "microservices-customer_account"
  }
}

resource "aws_vpc_peering_connection_accepter" "customer_account" {
  provider = aws.account

  vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  auto_accept               = true

  tags = {
    Name = "microservices-customer_account"
  }
}

resource "aws_vpc_peering_connection_options" "customer_account_requester" {
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "customer_account_accepter" {
  provider = aws.account

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}

# Account VPC <-> Statement VPC

resource "aws_vpc_peering_connection" "account_statement" {
  provider = aws.account

  vpc_id      = local.account_network.vpc_id
  peer_vpc_id = local.statement_network.vpc_id
  peer_region = local.statement_network.region
  auto_accept = false

  tags = {
    Name = "microservices-account_statement"
  }
}

resource "aws_vpc_peering_connection_accepter" "account_statement" {
  provider = aws.statement

  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
  auto_accept               = true

  tags = {
    Name = "microservices-account_statement"
  }
}

resource "aws_vpc_peering_connection_options" "account_statement_requester" {
  provider = aws.account

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection_options" "account_statement_accepter" {
  provider = aws.statement

  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
