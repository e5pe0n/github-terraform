terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

locals {
  # branch => whether required status checks must run against the latest base
  protected_branches = {
    develop = false
    main    = true
  }
}

resource "github_repository_ruleset" "branch" {
  for_each = local.protected_branches

  repository  = var.repository
  name        = each.key
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/${each.key}"]
      exclude = []
    }
  }

  rules {
    deletion         = true
    non_fast_forward = true

    dynamic "required_status_checks" {
      for_each = length(var.required_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = each.value
        do_not_enforce_on_create             = false

        dynamic "required_check" {
          for_each = var.required_status_checks
          content {
            context        = required_check.value
            integration_id = local.github_actions_app_id
          }
        }
      }
    }
  }
}
