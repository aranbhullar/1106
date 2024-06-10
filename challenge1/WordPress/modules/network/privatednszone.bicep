@description('DNS Zone Name')
param zoneName string
@description('A Record of Resource')
param aRecords array

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: zoneName
  location: 'global'
}

resource aRecordSets 'Microsoft.Network/privateDnsZones/A@2020-06-01' = [for aRecord in aRecords: {
  parent: privateDnsZone
  name: aRecord.name
  properties: {
    ttl: aRecord.ttl
    aRecords: [
      {
        ipv4Address: aRecord.ipv4Address
      }
    ]
  }
}]
