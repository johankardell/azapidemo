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


resource "azapi_resource" "storage" {
  type      = "Microsoft.Storage/storageAccounts@2021-08-01"
  name      = "saazapidemo"
  parent_id = azurerm_resource_group.azapi.id

  location = azurerm_resource_group.azapi.location
  body = jsonencode({
    properties = {
      accessTier : "Hot",
      minimumTlsVersion : "TLS1_2"
      supportsHttpsTrafficOnly : true
      allowBlobPublicAccess : false
      allowSharedKeyAccess : false
      allowCrossTenantReplication : false
      defaultToOAuthAuthentication : false
      networkAcls : {
        bypass : "AzureServices"
        defaultAction : "Deny"
        ipRules : []
      },
      encryption : {
        keySource : "Microsoft.Storage"
        services : {
          blob : {
            enabled : true
          },
          file : {
            enabled : true
          },
          table : {
            enabled : true
          },
          queue : {
            enabled : true
          }
        },
        requireInfrastructureEncryption : true
      }
    },
    sku : {
      name : "Standard_LRS"
    },
    kind : "StorageV2"
  })
}
