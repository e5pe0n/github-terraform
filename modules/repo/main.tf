terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }
}

resource "github_repository" "this" {
  name        = var.name
  description = var.description
  visibility  = "public"

  has_issues      = false
  has_projects    = true
  has_wiki        = false
  has_discussions = false

  allow_merge_commit          = true
  allow_squash_merge          = true
  allow_rebase_merge          = true
  allow_auto_merge            = true
  allow_update_branch         = false
  delete_branch_on_merge      = true
  merge_commit_title          = "MERGE_MESSAGE"
  merge_commit_message        = "PR_TITLE"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  squash_merge_commit_message = "COMMIT_MESSAGES"
  web_commit_signoff_required = false

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }

  archive_on_destroy = true

  lifecycle {
    prevent_destroy = true
  }
}

resource "github_repository_vulnerability_alerts" "this" {
  repository = github_repository.this.name
  enabled    = true
}

resource "github_repository_dependabot_security_updates" "this" {
  repository = github_repository.this.name
  enabled    = true

  depends_on = [github_repository_vulnerability_alerts.this]
}

resource "github_actions_repository_permissions" "this" {
  repository           = github_repository.this.name
  enabled              = true
  allowed_actions      = "all"
  sha_pinning_required = true
}

resource "github_workflow_repository_permissions" "this" {
  repository                       = github_repository.this.name
  default_workflow_permissions     = "read"
  can_approve_pull_request_reviews = false
}

# Git-flow style: develop is the default branch, main is the release branch.
resource "github_branch" "develop" {
  repository    = github_repository.this.name
  branch        = "develop"
  source_branch = "main"

  lifecycle {
    ignore_changes = [source_branch, source_sha]
  }
}

resource "github_branch_default" "this" {
  repository = github_repository.this.name
  branch     = github_branch.develop.branch
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

  repository  = github_repository.this.name
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

  depends_on = [github_branch.develop]
}
