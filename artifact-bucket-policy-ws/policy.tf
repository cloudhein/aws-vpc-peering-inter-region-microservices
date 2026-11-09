# Customer artifacts: downloads only through this service's regional endpoint.
resource "aws_s3_bucket_policy" "customer_artifacts" {
  bucket = data.tfe_outputs.customer_network.nonsensitive_values.artifacts_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGetObjectThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.customer_network.nonsensitive_values.artifacts_bucket}/customer-profile"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.customer_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      },
      {
        Sid       = "AllowListBucketThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.customer_network.nonsensitive_values.artifacts_bucket}"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.customer_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      }
    ]
  })
}

# Account artifacts: downloads only through this service's regional endpoint.
resource "aws_s3_bucket_policy" "account_artifacts" {
  provider = aws.account

  bucket = data.tfe_outputs.account_network.nonsensitive_values.artifacts_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGetObjectThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.account_network.nonsensitive_values.artifacts_bucket}/account"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.account_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      },
      {
        Sid       = "AllowListBucketThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.account_network.nonsensitive_values.artifacts_bucket}"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.account_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      }
    ]
  })
}

# Statement artifacts: downloads only through this service's regional endpoint.
resource "aws_s3_bucket_policy" "statement_artifacts" {
  provider = aws.statement

  bucket = data.tfe_outputs.statement_network.nonsensitive_values.artifacts_bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGetObjectThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.statement_network.nonsensitive_values.artifacts_bucket}/statement"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.statement_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      },
      {
        Sid       = "AllowListBucketThroughServiceEndpoint"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:ListBucket"
        Resource  = "arn:aws:s3:::${data.tfe_outputs.statement_network.nonsensitive_values.artifacts_bucket}"

        Condition = {
          StringEquals = {
            "aws:SourceVpce" = data.tfe_outputs.statement_network.nonsensitive_values.s3_endpoint_id
          }
          Bool = {
            "aws:SecureTransport" = "true"
          }
        }
      }
    ]
  })
}
