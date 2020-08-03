data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_data_factory" "this" {
  for_each            = var.data_factory
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  identity {
    type = "SystemAssigned"
  }

  dynamic "github_configuration" {
    for_each = lookup(var.github_configuration, "github_configuration", null) == null ? [] : [lookup(var.github_configuration, "github_configuration", null)]
    content {
      account_name    = github_configuration.value.account_name
      branch_name     = github_configuration.value.branch_name
      git_url         = github_configuration.value.git_url
      repository_name = github_configuration.value.repository_name
      root_folder     = github_configuration.value.root_folder
    }
  }

  dynamic "vsts_configuration" {
    for_each = lookup(each.value, "vsts_configuration", null) == null ? [] : [lookup(each.value, "vsts_configuration", null)]
    content {
      account_name    = vsts_configuration.value.account_name
      branch_name     = vsts_configuration.value.branch_name
      project_name    = vsts_configuration.value.project_name
      repository_name = vsts_configuration.value.repository_name
      root_folder     = vsts_configuration.value.root_folder
      tenant_id       = vsts_configuration.value.tenant_id
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "logs" {
  count                      = var.diagnostics.enable ? 1 : 0
  name                       = format("%v-diagnostics", azurerm_data_factory.this.name)
  target_resource_id         = azurerm_data_factory.this.id
  log_analytics_workspace_id = var.diagnostics.workspace_id

  log {
    category = "ActivityRuns"
  }
  log {
    category = "PipelineRuns"
  }
  log {
    category = "TriggerRuns"
  }
  metric {
    category = "AllMetrics"
  }
}
