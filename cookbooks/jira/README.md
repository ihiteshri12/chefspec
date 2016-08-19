# JIRA
This cookbook installs JIRA with latest stable Nginx as reverse proxy and MySQL as database.

## Supported JIRA versions

- JIRA 6.X.X
- JIRA 7.X.X

## Supported Platforms
### Tested And Validated On

- CentOS 6

## Usage

### jira::default
Install and Configure MySQL, JIRA, Nginx

### jira::database
Recipe to install and configure MySQL database

### jira::installer
Recipe to install JIRA

### jira::configuration
Recipe to configure JIRA and Machine

### jira::nginx

Recipe to install and configure latest stable Nginx

## Attributes

node['jira']['database']['host'] - MySQL database hostname

node['jira']['database']['name'] - MySQL database name    

node['jira']['database']['user'] - MySQL database user    

node['jira']['database']['password'] - MySQL database passowrd

node['jira']['database']['port'] - MySQL database port

node['jira']['version'] - JIRA version to be installed         

node['jira']['home_path'] - JIRA Home directory path        

node['jira']['install_path'] - JIRA installation directory path

node['jira']['user'] - JIRA user        

node['jira']['group'] - JIRA group      

node['jira']['jvm']['minimum_memory'] - JVM minimum memory for JIRA

node['jira']['jvm']['maximum_memory'] - JVM maximum memory for JIRA

## User credential

username - bdyck  
password - auto%%lab  

username  - rbreckenridge  
password  - auto%%lab  