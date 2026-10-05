# github-terraform

Applies a shared set of repository settings (modelled on `e5pe0n/stden`) to the repos listed in [main.tf](main.tf), split into `local.public_repos` and `local.private_repos`.

Public repos also get `develop`/`main` branch rulesets. Private repos don't, because GitHub Free has no rulesets (or secret scanning) on private repos.

## Usage

```sh
export GITHUB_TOKEN=$(gh auth token)
terraform init
terraform plan
terraform apply
```

## Adding a repo

1. Add an entry in [main.tf](main.tf):
   - Public: add it to `local.public_repos`. Set `required_status_checks` to the CI job names that must pass (use `[]` if the repo has no CI yet).
   - Private: add it to `local.private_repos`. Set `gitflow = true` to use `develop` as the default branch, or `false` to keep `main`.
2. Existing repos are imported automatically by the `for_each` imports in [imports.tf](imports.tf). If a repo already has a `develop` branch or `develop`/`main` rulesets, add explicit `import` blocks for them, as done for `stden`.
3. `terraform plan`, review, `terraform apply`.

State is local (`terraform.tfstate`, git-ignored) — keep it safe or move it to a remote backend.
