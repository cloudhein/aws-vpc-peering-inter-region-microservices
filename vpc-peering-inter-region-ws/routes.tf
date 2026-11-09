# Customer private route tables -> Account private subnets
# One shared customer private route table -> both account private subnets

resource "aws_route" "customer_to_account_subnet_1" {
  route_table_id            = local.customer_network.private_route_table_ids[0]
  destination_cidr_block    = local.account_network.private_subnet_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id
}

resource "aws_route" "customer_to_account_subnet_2" {
  route_table_id            = local.customer_network.private_route_table_ids[0]
  destination_cidr_block    = local.account_network.private_subnet_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id
}

# Account private route tables -> Customer private subnets
# One shared account private route table -> both customer private subnets

resource "aws_route" "account_to_customer_subnet_1" {
  provider = aws.account

  route_table_id            = local.account_network.private_route_table_ids[0]
  destination_cidr_block    = local.customer_network.private_subnet_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id
}

resource "aws_route" "account_to_customer_subnet_2" {
  provider = aws.account

  route_table_id            = local.account_network.private_route_table_ids[0]
  destination_cidr_block    = local.customer_network.private_subnet_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.customer_account.id
}

# Account private route tables -> Statement private subnets
# One shared account private route table -> both statement private subnets

resource "aws_route" "account_to_statement_subnet_1" {
  provider = aws.account

  route_table_id            = local.account_network.private_route_table_ids[0]
  destination_cidr_block    = local.statement_network.private_subnet_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id
}

resource "aws_route" "account_to_statement_subnet_2" {
  provider = aws.account

  route_table_id            = local.account_network.private_route_table_ids[0]
  destination_cidr_block    = local.statement_network.private_subnet_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id
}

# Statement private route tables -> Account private subnets
# One shared statement private route table -> both account private subnets

resource "aws_route" "statement_to_account_subnet_1" {
  provider = aws.statement

  route_table_id            = local.statement_network.private_route_table_ids[0]
  destination_cidr_block    = local.account_network.private_subnet_cidrs[0]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id
}

resource "aws_route" "statement_to_account_subnet_2" {
  provider = aws.statement

  route_table_id            = local.statement_network.private_route_table_ids[0]
  destination_cidr_block    = local.account_network.private_subnet_cidrs[1]
  vpc_peering_connection_id = aws_vpc_peering_connection_accepter.account_statement.id
}
