# ELK Stack Local Deployment
## Overview
This guide provides instructions to run the ELK (Elasticsearch, Logstash, Kibana) stack locally using Docker Compose and how to discover logs in Kibana.

## Prerequisites
Docker and Docker Compose installed
Clone the repository containing the ELK stack configuration
## Steps
1. Create Docker Compose File
Create a file named docker-compose.yml in your project directory
2. Create Logstash Configuration
Create a directory named logstash/pipeline and a file named logstash.conf within it
3. Running the ELK Stack
Navigate to the directory containing docker-compose.yml and run:
```docker-compose up -d```
This starts the ELK stack in detached mode.

4. Verify the Services
Run the following command to ensure all services are running
```docker ps``

5. Place Log Files
Place your log files in the logstash/pipeline/logs directory for Logstash to process them.

6. Discover Logs in Kibana
Open Kibana at http://localhost:5601.
Navigate to Management > Stack Management > Index Patterns.
Create a new index pattern for logstash-*.
Go to Discover and select the logstash-* index pattern to view the logs.
Additional Notes
Check Logstash Logs: Ensure Logstash is processing the log files correctly by running docker logs logstash.
Verify Elasticsearch Data: You can check the data being indexed by Elasticsearch via its API at http://localhost:9200.


# LNAV -- The Logfile Navigator

Failed requests are shown in red. Identifiers, like IP address and PIDs are semantically highlighted.

## Steps 
Point lnav at the files or directories you want to monitor

```$ lnav /path/to/file1 /path/to/dir ...```