# starburst-sandbox
## About
The Starburst Sandbox is a community-driven initiative that aims to offer a rapid demonstration and development environment by leveraging docker-compose. Its primary objective is to showcase Data Products and BIAC functionalities to users. It is worth noting that this sandbox is not an officially supported project by Starburst Data and is not suitable for production purposes.
This Sandbox is based on the https://github.com/starburstdata/dbt-trino project and includes modification to enable Starburst Enterprise Features


## Prerequisites
- Docker or Rancher Desktop Version 1.8.1 
- 6GB RAM 2 Cores
- Access to the Starburst Harbor Registry
- A valid Starburst Enterprise License request here https://www.starburst.io/contact


## Installation

### Configure Starburst harbor registry

### Test access to Starburst harbor registry

### Clone the Github Repository

### Copy License File

`cp starburstdata.license ./docker/starburst/etc/starburstdata.license`

### Start Starburst 

`./start-starburst.sh`

### Validate that you are able to access the Endpoint

`http://localhost:8080`
