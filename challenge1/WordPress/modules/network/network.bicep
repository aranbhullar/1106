@description('Prefix of resources')
param prefix string
@description('Azure Location')
param location string
@description('Resource Tags')
param tags object = {}

// Define vNet names
var vnetName = '${prefix}-vnet'
var subnetNsgName = '${prefix}-subnet-nsg'

// Create Network Security Group
resource subnetNsg 'Microsoft.Network/networkSecurityGroups@2022-01-01' = {
  name: subnetNsgName
  location: location
  tags: tags
  properties: {
    securityRules: [
    ]
  }
}

// Create VNET
resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'containerapp-snet'
        properties: {
          addressPrefix: '10.0.0.0/23'
          networkSecurityGroup: {
            id: subnetNsg.id
          }
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

output containerappsSubnetid string = vnet.properties.subnets[0].id
