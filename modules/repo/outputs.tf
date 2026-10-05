# Read from github_branch_default so dependents wait until develop exists and is the default.
output "name" {
  description = "Repository name."
  value       = github_branch_default.this.repository
}
