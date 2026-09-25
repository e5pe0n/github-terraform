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
  repos = {
    stden = {
      required_status_checks = ["check"]
    }
    gim = {
      required_status_checks = []
    }
  }
}

module "repo" {
  source   = "./modules/repo"
  for_each = local.repos

  name                   = each.key
  required_status_checks = each.value.required_status_checks
}
