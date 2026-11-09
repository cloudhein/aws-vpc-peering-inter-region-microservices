# One app instance in the first private subnet, per the requested deployment.
resource "aws_instance" "app" {
  ami                         = coalesce(var.ami_id, data.aws_ami.ubuntu.id)
  instance_type               = var.instance_type
  subnet_id                   = local.network.private_subnet_ids[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [local.security.app_security_group_id]
  #iam_instance_profile        = local.security.instance_profile_name
  key_name = aws_key_pair.app.key_name
  

  user_data = templatefile("${path.module}/templates/statement.sh.tftpl", {
    artifacts_bucket = local.network.artifacts_bucket
    region           = var.region
  })
  user_data_replace_on_change = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }
  lifecycle {
    precondition {
      condition     = local.network.region == var.region
      error_message = "Network and compute workspaces must use the same Region."
    }
  }
  tags = {
    Name = "microservices-statement-app"
  }
}