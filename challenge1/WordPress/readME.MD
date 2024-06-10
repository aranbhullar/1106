# WordPress Deployment with Azure Front Door, MySQL Database, and PrivateLink

Deploy a WordPress application on Azure using:

- Azure Container Apps
- Azure Front Door
- Azure Database for MySQL Flexible Server
- PrivateLink
- Azure Files for storage

## Prerequisites

- Azure subscription
- Azure CLI installed
- Bicep CLI installed (optional if using Azure CLI directly)

## Deployment
### Parameters

Update the parameters in main.bicep:

prefix: Prefix for resource names
location: Azure region
tags: Tags for resources
appName: WordPress application name
administratorLogin: MySQL admin username

## Steps

### Clone the repository:

bash
Copy code
git clone https://github.com/your-repo/wordpress-bicep
cd wordpress-bicep

### Update Parameters:

Modify the parameters in main.bicep and the respective module files to match your desired configurations.

### Deploy the Bicep template:

bash
Copy code
az deployment group create --resource-group <resource-group-name> --template-file main.bicep
Outputs
wordpressUrl: URL of the deployed WordPress site
wordpressLatestCreatedRevision
wordpressLatestCreatedRevisionId
wordpressLatestReadyRevision
wordpressLatestReadyRevisionId

## Cleanup

To delete all resources:

bash
Copy code
az group delete --name <your-resource-group> --yes --no-wait

## Deploy withGithub Actions 

### Execute the deploy-infrastructure.yml workflow.

1. Under your repository name, click Actions .
2. In the left sidebar, click the workflow "Wordpress Deployment".
3. Above the list of workflow runs, select Run workflow .
4. Use the Branch dropdown to select the workflow's main branch, Click Run workflow .
