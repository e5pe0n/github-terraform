variable "repository" {
  description = "Repository name. Its develop and main branches must already exist."
  type        = string
}

variable "required_status_checks" {
  description = "Status check contexts (GitHub Actions job names) required on develop and main."
  type        = list(string)
  default     = []
}

locals {
  github_actions_app_id = 15368
}
