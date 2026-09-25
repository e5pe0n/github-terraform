variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
  default     = null
}

variable "required_status_checks" {
  description = "Status check contexts (GitHub Actions job names) required on develop and main."
  type        = list(string)
  default     = []
}

locals {
  github_actions_app_id = 15368
}
