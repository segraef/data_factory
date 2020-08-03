variable "resource_group_name" {
  description = "(Required) Name of the resource group."
}

variable "data_factory" {
  description = "(Required) Configuration of the resource."
  type = map(object({
    name = string
    vsts_configuration = object({
      account_name    = string
      branch_name     = string
      project_name    = string
      repository_name = string
      root_folder     = string
      tenant_id       = string
    })
    github_configuration = object({
      account_name    = string
      branch_name     = string
      git_url         = string
      repository_name = string
      root_folder     = string
    })
  }))
}

variable "diagnostics" {
  description = "(Optional) Specifies whether and where Diagnostics Data should be sent to. Changing this forces a new resource to be created."
  type = object({
    enable       = bool
    workspace_id = string
  })
  default = {
    enable       = false
    workspace_id = null
  }
}

variable "tags" {
  description = "(Optional) Tags to assign to the Key Vault."
  type        = map
  default     = null
}

# variable "github_configuration" {
#   description = "(Optional) A github_configuration or vsts_configuration block."
#   type = object({
#       account_name    = string
#       branch_name     = string
#       git_url         = string
#       repository_name = string
#       root_folder     = string
#     })
#   default = {
#       account_name    = null
#       branch_name     = null
#       git_url         = null
#       repository_name = null
#       root_folder     = null
#   }
# }

# variable "vsts_configuration" {
#   description = "(Optional) A github_configuration or vsts_configuration block."
#   type = object({
#       account_name    = string
#       branch_name     = string
#       project_name    = string
#       repository_name = string
#       root_folder     = string
#       tenant_id       = string
#     })
#   default = {
#       account_name    = null
#       branch_name     = null
#       project_name    = null
#       repository_name = null
#       root_folder     = null
#       tenant_id       = null
#   }
# }
