# Adopt existing repositories and their settings into state.
# Every repo in local.repos already exists on GitHub, so each is imported rather than created.

import {
  for_each = local.repos
  to       = module.repo[each.key].github_repository.this
  id       = each.key
}

import {
  for_each = local.repos
  to       = module.repo[each.key].github_repository_vulnerability_alerts.this
  id       = each.key
}

import {
  for_each = local.repos
  to       = module.repo[each.key].github_repository_dependabot_security_updates.this
  id       = each.key
}

import {
  for_each = local.repos
  to       = module.repo[each.key].github_actions_repository_permissions.this
  id       = each.key
}

import {
  for_each = local.repos
  to       = module.repo[each.key].github_workflow_repository_permissions.this
  id       = each.key
}

import {
  for_each = local.repos
  to       = module.repo[each.key].github_branch_default.this
  id       = each.key
}

# Resources that only exist on some repos.

import {
  to = module.repo["stden"].github_branch.develop
  id = "stden:develop"
}

import {
  to = module.repo["stden"].github_repository_ruleset.branch["develop"]
  id = "stden:22318824"
}

import {
  to = module.repo["stden"].github_repository_ruleset.branch["main"]
  id = "stden:22318852"
}
