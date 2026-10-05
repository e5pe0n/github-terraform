variable "name" {
  description = "Repository name."
  type        = string
}

variable "description" {
  description = "Repository description."
  type        = string
  default     = null
}

variable "visibility" {
  description = "Repository visibility: public or private."
  type        = string

  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "visibility must be \"public\" or \"private\"."
  }
}

variable "gitflow" {
  description = "Use develop as the default branch with main as the release branch. When false, main is the default branch."
  type        = bool
  default     = true
}
