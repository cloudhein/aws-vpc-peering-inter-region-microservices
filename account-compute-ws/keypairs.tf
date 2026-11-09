data "aws_secretsmanager_secret_version" "app_public_key" {
  secret_id = var.ssh_public_key_secret_id
}

resource "aws_key_pair" "app" {
  key_name = "microservices-ssh-key"

  public_key = trimspace(
    data.aws_secretsmanager_secret_version.app_public_key.secret_string
  )
}