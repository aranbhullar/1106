@description('Specifies the Azure Region for deploying resources.')
param location string
@description('A prefix used for naming resources to ensure uniqueness.')
param prefix string
@description('The name for the WordPress container application.')
param appName string
@description('A dictionary of tags to be applied to all resources.')
param tags object = {}
@description('Use Managed Identity for the storage account.')
param identity string
@description('Image for the WordPress container application.')
param image string

// Create an azure files storage for photos/files uploaded to wordpress.
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueString(resourceGroup().name)
  location: location
  tags: tags
  sku: {
    name: 'Premium_LRS'
  }
  kind: 'FileStorage'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${identity}': {}
    }
  }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    publicNetworkAccess: 'Enabled'
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }

  resource fileService 'fileServices@2022-09-01' = {
    name: 'default'
    resource fileShare 'shares@2022-09-01' = {
      name: 'wp-share'
      properties: {
        enabledProtocols: 'SMB'
        accessTier: 'Premium'
      }
    }
  }
}

// container app environment with attached storage
resource appEnv 'Microsoft.App/managedEnvironments@2023-04-01-preview' = {
  name: '${prefix}-aca-env'
  location: location
  tags: tags
  properties: {
    appLogsConfiguration: {
      destination: 'azure-monitor'
    }
  }

  resource azureFilesStorage 'storages@2022-11-01-preview' = {
    name: 'azurefilesstorage'
    properties: {
      azureFile: {
        accountName: storageAccount.name
        shareName: storageAccount::fileService::fileShare.name
        accessMode: 'ReadWrite'
        accountKey: storageAccount.listKeys().keys[0].value
      }
    }
  }
}

// mariadb service
resource mariadb 'Microsoft.App/containerApps@2023-04-01-preview' = {
  name: 'mariadb'
  location: location
  tags: tags
  properties: {
    environmentId: appEnv.id
    configuration: {
      service: {
        type: 'mariadb'
      }
    }
  }
}

// wordpress app
resource wordpress 'Microsoft.App/containerApps@2023-04-01-preview' = {
  name: '${prefix}-${appName}'
  location: location
  tags: tags
  properties: {
    environmentId: appEnv.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
    template: {
      serviceBinds: [
        {
          serviceId: mariadb.id
          name: 'mariadb'
        }
      ]
      containers: [
        {
          name: 'wordpress'
          image: image
          volumeMounts: [
            {
              mountPath: '/var/www/html'
              volumeName: 'wp-volume'
            }
          ]
          command: [
            '/bin/sh'
          ]
          args: [
            '-c'
            '''export WORDPRESS_DB_HOST="$MARIADB_HOST" && \
            export WORDPRESS_DB_NAME="$MARIADB_DATABASE" && \
            export WORDPRESS_DB_USER="$MARIADB_USERNAME" && \
            export WORDPRESS_DB_PASSWORD="$MARIADB_PASSWORD" && \
            docker-entrypoint.sh apache2-foreground'''
          ]
          env: [
            {
              name: 'AZURE_STORAGE_USE_MANAGED_IDENTITY'
              value: 'true'
            }
          ]
          resources: {
            cpu: json('1.0')
            memory: '2.0Gi'
          }
        }
      ]
      volumes: [
        {
          name: 'wp-volume'
          storageName: appEnv::azureFilesStorage.name
          storageType: 'AzureFile'
        }
      ]
    }
  }
}

output wordpressUrl string = 'https://${wordpress.properties.configuration.ingress.fqdn}'
output wordpressLatestCreatedRevision string = wordpress.properties.latestRevisionName
output wordpressLatestCreatedRevisionId string = '${wordpress.id}/revisions/${wordpress.properties.latestRevisionName}'
output wordpressLatestReadyRevision string = wordpress.properties.latestReadyRevisionName
output wordpressLatestReadyRevisionId string = '${wordpress.id}/revisions/${wordpress.properties.latestReadyRevisionName}'
output azWordpressLogs string = 'az containerapp logs show -n ${wordpress.name} -g ${resourceGroup().name} --revision ${wordpress.properties.latestRevisionName} --follow --tail 30'
output azWordpressExec string = 'az containerapp exec -n ${wordpress.name} -g ${resourceGroup().name} --revision ${wordpress.properties.latestRevisionName} --command /bin/bash'
output azShowWordpressRevision string = 'az containerapp revision show -n ${wordpress.name} -g ${resourceGroup().name} --revision ${wordpress.properties.latestRevisionName}'
