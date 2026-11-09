# Collect the eight private routes.
locals {
  private_routes = [
    aws_route.customer_to_account_subnet_1,
    aws_route.customer_to_account_subnet_2,
    aws_route.account_to_customer_subnet_1,
    aws_route.account_to_customer_subnet_2,
    aws_route.account_to_statement_subnet_1,
    aws_route.account_to_statement_subnet_2,
    aws_route.statement_to_account_subnet_1,
    aws_route.statement_to_account_subnet_2,
  ]
}

output "private_route_count" {
  value = length(local.private_routes)
}