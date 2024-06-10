targetScope = 'resourceGroup'
param location string = resourceGroup().location
param prefix string = 'test'
param tags object = {
  environment: 'test'
  project: 'Container Apps'
}
param appName string = 'simplewp'
param image string = 'wordpress:latest'

var kvName = 'challenge1'
var kvResourceGroup = location

// Deploy Managed Identity for Wordpress
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'wordpressManagedIdentity'
  location: location
}

// Deploy Wordpress Application and dependencies
module wordpressApp './modules/application/wordpress.bicep' = {
  name: 'wordpressDeployment'
  params: {
    location: location
    appName: appName
    prefix: prefix
    tags: tags
    identity: managedIdentity.id
    image: image
  }
}

// Use Keyvault for secrets
// resource kv 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
//   name: kvName
//   scope: resourceGroup(subscriptionId, kvResourceGroup)
// }

// Reference the existing Azure Container Registry (ACR)
// resource acr 'Microsoft.ContainerRegistry/registries@2021-06-01' existing = {
//   name: acrName
// }

// CODE TO PRODUCTIONIZE 
// Container App in vNet, Subnet, NSG. 
// Deploy seperate Database and Redis Cache. 
// Deploy Frontdoor and CDN to access Container App.

// Deploy Network  and dependencies
// module network './modules/network/network.bicep' = {
//   name: 'networkDeployment'
//   params: {
//     location: location
//     prefix: prefix
//     tags: tags
//   }
// }

// Deploy Frontdoor and CDN
// module network './modules/network/frontdoor.bicep' = {
//   name: 'databaseDeployment'
//   params: {
//     location: location
//     prefix: prefix
//     administratorLogin: administratorLogin
//     administratorLoginPassword:'test'
//   }
// }

// Deploy Wordpress Database and dependencies
// module database './modules/database.bicep' = {
//   name: 'databaseDeployment'
//   params: {
//     location: location
//     prefix: prefix
//     administratorLogin: administratorLogin
//     administratorLoginPassword:'test'
//   }
// }
