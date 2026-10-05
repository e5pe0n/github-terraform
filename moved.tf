# Branches became optional (count) when git-flow was made configurable per repo.
moved {
  from = module.repo["stden"].github_branch.develop
  to   = module.repo["stden"].github_branch.develop[0]
}

moved {
  from = module.repo["gim"].github_branch.develop
  to   = module.repo["gim"].github_branch.develop[0]
}

moved {
  from = module.repo["shushu"].github_branch.develop
  to   = module.repo["shushu"].github_branch.develop[0]
}

# Rulesets moved out of the repo module so they only apply to public repos.
moved {
  from = module.repo["stden"].github_repository_ruleset.branch
  to   = module.branch_rulesets["stden"].github_repository_ruleset.branch
}

moved {
  from = module.repo["gim"].github_repository_ruleset.branch
  to   = module.branch_rulesets["gim"].github_repository_ruleset.branch
}

# shushu went private, where GitHub Free can't read rulesets (403); drop them from state without destroying.
removed {
  from = module.repo.github_repository_ruleset.branch

  lifecycle {
    destroy = false
  }
}
