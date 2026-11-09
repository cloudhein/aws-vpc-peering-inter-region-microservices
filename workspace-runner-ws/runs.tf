# Run one workspace at a time, including independent services, so the controller
# works with a single HCP run slot. Each run waits for its target to complete.
# Terraform reverses this dependency chain during terraform destroy.

# 1. All network workspaces.
resource "tfe_workspace_run" "customer_network" {
  workspace_id = data.tfe_workspace.target["customer_network"].id

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "account_network" {
  workspace_id = data.tfe_workspace.target["account_network"].id

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "statement_network" {
  workspace_id = data.tfe_workspace.target["statement_network"].id

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# 2. The three regional bucket policies, after all endpoint outputs are available.
resource "tfe_workspace_run" "artifact_policy" {
  workspace_id = data.tfe_workspace.target["artifact_policy"].id
  depends_on   = [tfe_workspace_run.customer_network, tfe_workspace_run.account_network, tfe_workspace_run.statement_network]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# 3. All security workspaces, after the artifact bucket policy.
resource "tfe_workspace_run" "customer_security" {
  workspace_id = data.tfe_workspace.target["customer_security"].id
  depends_on   = [tfe_workspace_run.customer_network, tfe_workspace_run.artifact_policy]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "account_security" {
  workspace_id = data.tfe_workspace.target["account_security"].id
  depends_on   = [tfe_workspace_run.account_network, tfe_workspace_run.artifact_policy]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "statement_security" {
  workspace_id = data.tfe_workspace.target["statement_security"].id
  depends_on   = [tfe_workspace_run.statement_network, tfe_workspace_run.artifact_policy]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# 4. Peering consumes Network, Security.
resource "tfe_workspace_run" "peering" {
  workspace_id = data.tfe_workspace.target["peering"].id
  depends_on   = [tfe_workspace_run.customer_security, tfe_workspace_run.account_security, tfe_workspace_run.statement_security]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# 5. All compute workspaces. Each creates its own regional EC2 key pair.
# Keep the existing Statement-first run order.
resource "tfe_workspace_run" "statement_compute" {
  workspace_id = data.tfe_workspace.target["statement_compute"].id
  depends_on   = [tfe_workspace_run.statement_security, tfe_workspace_run.peering]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "account_compute" {
  workspace_id = data.tfe_workspace.target["account_compute"].id
  depends_on   = [tfe_workspace_run.account_security, tfe_workspace_run.peering]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

resource "tfe_workspace_run" "customer_compute" {
  workspace_id = data.tfe_workspace.target["customer_compute"].id
  depends_on   = [tfe_workspace_run.customer_security, tfe_workspace_run.peering]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

# 6. Private DNS consumes outputs from all three network & compute workspaces
resource "tfe_workspace_run" "private_dns" {
  workspace_id = data.tfe_workspace.target["private_dns"].id
  depends_on   = [tfe_workspace_run.customer_compute, tfe_workspace_run.account_compute, tfe_workspace_run.statement_compute]

  apply {
    manual_confirm = false
    wait_for_run   = true
  }

  destroy {
    manual_confirm = false
    wait_for_run   = true
  }
}

