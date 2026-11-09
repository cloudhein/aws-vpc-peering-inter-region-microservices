output "region" {
  value = var.region
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "private_subnet_cidrs" {
  value = aws_subnet.private_subnet[*].cidr_block
}

output "private_route_table_ids" {
  value = aws_route_table.private_rt[*].id
}

output "s3_endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "s3_prefix_list_id" {
  value = aws_vpc_endpoint.s3.prefix_list_id
}

output "artifacts_bucket" {
  value = var.artifacts_bucket
}

# output "artifact_key" {
#   value = "statement"
# }

output "aws_statement_vpc_endpoint_s3_id" {
  value = aws_vpc_endpoint.s3.id
}