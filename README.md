# github-terraform

Applies a shared set of repository settings (modelled on `e5pe0n/stden`) to the repos listed in `local.repos` in [main.tf](main.tf).

## Usage

```sh
export GITHUB_TOKEN=$(gh auth token)
terraform init
terraform plan
terraform apply
```

## Adding a repo

1. Add an entry to `local.repos` in [main.tf](main.tf). Set `required_status_checks` to the CI job names that must pass (use `[]` if the repo has no CI yet).
2. Existing repos are imported automatically by the `for_each` imports in [imports.tf](imports.tf). If the repo already has a `develop` branch or `develop`/`main` rulesets, add explicit `import` blocks for them, as done for `stden`.
3. `terraform plan`, review, `terraform apply`.

State is local (`terraform.tfstate`, git-ignored) — keep it safe or move it to a remote backend.
