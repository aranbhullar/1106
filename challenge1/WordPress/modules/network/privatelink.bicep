@description('Prefix of resources')
param prefix string
@description('Azure Location')
param location string
@description('VNET Subnet ID')
param vnetSubnetId string
@description('Azure Container Apps Default Domain')
param containerAppsDefaultDomainName string
@description('Resource Tags')
param tags object = {}
param privateLinkServiceName string = '${prefix}-aca-env-pl'

var containerAppsDefaultDomainArray = split(containerAppsDefaultDomainName, '.')
var containerAppsNameIdentifier = containerAppsDefaultDomainArray[lastIndexOf(containerAppsDefaultDomainArray, location)-1]
var containerAppsManagedResourceGroup = 'MC_${containerAppsNameIdentifier}-rg_${containerAppsNameIdentifier}_${location}'

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-05-01' existing = {
  name: 'kubernetes-internal'
  scope: resourceGroup(containerAppsManagedResourceGroup)
}

resource privateLinkService 'Microsoft.Network/privateLinkServices@2022-01-01' = {
  name: privateLinkServiceName
  location: location
  tags: tags
  properties: {
    loadBalancerFrontendIpConfigurations: [
      {
        id: loadBalancer.properties.frontendIPConfigurations[0].id
      }
    ]
    ipConfigurations: [
      {
        name: 'snet-provider-default-1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: vnetSubnetId
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}

output privateLinkServiceName string = privateLinkService.name
output privateLinkServiceId string = privateLinkService.id
