@description('Prefix of resources')
param prefix string
@description('Azure Location')
param location string 
@description('Private Link Service ID')
param privateLinkServiceId string
@description('App Hostname')
param frontDoorAppHostName string
@description('Resoucrce Tags')
param tags object = {}

// Define names
var frontDoorProfileName = '${prefix}-fd'
var frontDoorEndpointName = '${prefix}-fd-endpoint'
var frontDoorOriginGroupName = '${prefix}-fd-og'
var frontDoorOriginRouteName = '${prefix}-fd-route'
var frontDoorOriginName = '${prefix}-fd-origin'


resource frontDoorProfile 'Microsoft.Cdn/profiles@2022-05-01-preview' = {
  name: frontDoorProfileName
  location: 'Global'
  tags: tags
  sku: {
    name: 'App_AzureFrontDoor'
  }
  properties: {
    originResponseTimeoutSeconds: 120
  }
}

resource frontDoorEndpoint 'Microsoft.Cdn/profiles/afdendpoints@2022-05-01-preview' = {
  parent: frontDoorProfile
  name: frontDoorEndpointName
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}

resource frontDoorOriginGroup 'Microsoft.Cdn/profiles/origingroups@2022-05-01-preview' = {
  parent: frontDoorProfile
  name: frontDoorOriginGroupName
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/health'
      probeRequestType: 'HEAD'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
}

resource frontDoorOrigin 'Microsoft.Cdn/profiles/origingroups/origins@2022-05-01-preview' = {
  parent: frontDoorOriginGroup
  name: frontDoorOriginName
  properties: {
    hostName: frontDoorAppHostName
    httpPort: 80
    httpsPort: 443
    originHostHeader: frontDoorAppHostName
    priority: 1
    weight: 1000
    enabledState: 'Enabled'
    sharedPrivateLinkResource: {
      privateLink: {
        id: privateLinkServiceId
      }
      privateLinkLocation: location
      requestMessage: 'frontdoor'
    }
    enforceCertificateNameCheck: true
  }
}

resource frontDoorOriginRoute 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-05-01-preview' = {
  parent: frontDoorEndpoint
  name: frontDoorOriginRouteName
  properties: {
    originGroup: {
      id: frontDoorOriginGroup.id
    }
    originPath: '/'
    ruleSets: []
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'HttpsOnly'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }

  dependsOn: [
    frontDoorOrigin
  ]
}

output fqdn string = frontDoorEndpoint.properties.hostName
