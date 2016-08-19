#
# Cookbook Name:: jira
# Recipe:: database
#
# Copyright (c) 2016 Teradici Corp., All Rights Reserved.
# Recipe to install and configure MySQL database

# Set Selinux into Permissive mode
# If Selinux is not set into Permissive mode, MySQL service fails to start
include_recipe 'selinux::permissive'

# Host and Port for database connection
database_connection = {
  :host => node['jira']['database']['host'],
  :port => node['jira']['database']['port']
}

# Install mysql2_chef_gem
mysql2_chef_gem 'jira' do
  client_version node['jira']['database']['version'] if node['jira']['database']['version']
  action :install
end

# Setup MySQL with desired database
mysql_service 'mysql' do
  version node['jira']['database']['version'] if node['jira']['database']['version']
  bind_address node['jira']['database']['host']
  port node['jira']['database']['port'].to_s
  initial_root_password node['mysql']['server_root_password']
  data_dir node['mysql']['data_dir'] if node['mysql']['data_dir']
  action [:create, :start]
end

# Database username and password for database connection
database_connection[:username] = 'root'
database_connection[:password] = node['mysql']['server_root_password']

# Create JIRA database
mysql_database node['jira']['database']['name'] do
  connection database_connection
  collation 'utf8_bin'
  encoding 'utf8'
  action :create
end

# For security remove empty users
mysql_database_user '' do
  connection database_connection
  host 'localhost'
  action :drop
end

# Create JIRA user and set up access to JIRA database 
mysql_database_user node['jira']['database']['user'] do
  connection database_connection
  host '%'
  password node['jira']['database']['password']
  database_name node['jira']['database']['name']
  action [:create, :grant]
end
