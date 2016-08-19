#
# Cookbook Name:: jira
# Recipe:: default
#
# Copyright (c) 2016 Teradici Corp., All Rights Reserved.

# Recipe to install and configure MySQL database
include_recipe 'jira::database' if node['jira']['database']['host'] == '127.0.0.1'

# Recipe to install JIRA
include_recipe "jira::installer"

# Recipe to configure JIRA and Machine
include_recipe 'jira::configuration'

# Recipe to install and configure latest stable Nginx
include_recipe 'jira::nginx'
