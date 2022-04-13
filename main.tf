resource "azurerm_resource_group" "azapi" {
  name     = "azapi-demo"
  location = "Sweden Central"
}

// create a automation account
resource "azapi_resource" "automationAccount" {
  type      = "Microsoft.Automation/automationAccounts@2021-06-22"
  name      = "myAccount"
  parent_id = azurerm_resource_group.azapi.id

  location = azurerm_resource_group.azapi.location
  body = jsonencode({
    properties = {
      disableLocalAuth    = true
      publicNetworkAccess = false
      sku = {
        name = "Basic"
      }
    }
  })
}
