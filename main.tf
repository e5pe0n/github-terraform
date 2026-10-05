terraform {
  required_version = ">= 1.7"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.13"
    }
  }
}

# Authenticates with GITHUB_TOKEN, e.g. `export GITHUB_TOKEN=$(gh auth token)`.
provider "github" {
  owner = "e5pe0n"
}

locals {
  # Public repos get git-flow branch rulesets, which GitHub Free does not offer on private repos.
  public_repos = {
    stden = {
      required_status_checks = ["check"]
    }
    gim = {
      required_status_checks = []
    }
  }

  private_repos = {
    shushu = {
      gitflow = true
    }
    infra = {
      gitflow = false
    }
  }

  repos = merge(
    { for name, _ in local.public_repos : name => { visibility = "public", gitflow = true } },
    { for name, repo in local.private_repos : name => { visibility = "private", gitflow = repo.gitflow } },
  )
}

module "repo" {
  source   = "./modules/repo"
  for_each = local.repos

  name       = each.key
  visibility = each.value.visibility
  gitflow    = each.value.gitflow
}

module "branch_rulesets" {
  source   = "./modules/branch_rulesets"
  for_each = local.public_repos

  repository             = module.repo[each.key].name
  required_status_checks = each.value.required_status_checks
}
