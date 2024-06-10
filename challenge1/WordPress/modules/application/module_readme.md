# WordPress Container Deployment Module
This module automates the deployment of a WordPress application on Azure by utilizing Azure Container Apps and managed Azure Storage.

## Overview
This module creates the following resources:

Azure Files Storage: Premium Azure storage account for uploading photos and files used by WordPress.
Container App Environment: Managed environment for running containerized applications, including attached Azure Files Storage.
MariaDB Service: Database service for WordPress, using MariaDB.
WordPress Application: Containerized WordPress application running on Azure Container Apps.
## Parameters
location: Specifies the Azure region for deploying resources.
prefix: Prefix used for naming resources to ensure uniqueness.
appName: Name for the WordPress container application.
tags: Dictionary of tags to be applied to all resources.
identity: Option to use a managed identity for the storage account.
## Outputs
wordpressUrl: URL for accessing the deployed WordPress application.
wordpressLatestCreatedRevision: Name of the latest created revision of the WordPress application.
wordpressLatestCreatedRevisionId: ID of the latest created revision of the WordPress application.
wordpressLatestReadyRevision: Name of the latest ready revision of the WordPress application.
wordpressLatestReadyRevisionId: ID of the latest ready revision of the WordPress application.
azWordpressLogs: Command to show logs of the WordPress application.
azWordpressExec: Command to execute commands in the WordPress application container.
azShowWordpressRevision: Command to show details of the latest revision of the WordPress application.