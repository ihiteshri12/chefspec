#
# Cookbook Name:: jira
# Recipe:: nginx
#
# Copyright (c) 2016 Teradici Corp., All Rights Reserved.

# Setup Nginx official repo
template '/etc/yum.repos.d/nginx.repo' do
  source 'nginx.repo.erb'
  owner 'root'
  group 'root'
  mode '0600'
end

# Install latest stable Nginx
yum_package 'nginx' do
  flush_cache [ :before ]
  action :install
end

# Setup Nginx.conf
template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  notifies :restart, 'service[nginx]', :delayed
end

# Create sites-available directory
directory '/etc/nginx/sites-available' do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
  recursive true
end

# JIRA reverse Proxy configuration file
template '/etc/nginx/sites-available/jira-https-proxy.conf' do
  source 'jira-https-proxy.conf.erb'
  owner 'root'
  group 'root'
  mode '0600'
  variables(
    :server_name => node['jira']['server_name']
  )
  notifies :restart, 'service[nginx]', :delayed
end

# Create SSL directory
%w[ /etc/ssl /etc/ssl/private /etc/ssl/private/nginx ].each do |dirs|
  directory dirs do
    owner 'root'
    group 'root'
    mode '0700'
    action :create
  end
end

# Setup SSL certificate
cookbook_file '/etc/ssl/private/nginx/jira_teradici_com.crt' do
  source 'jira_teradici_com.crt'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

# Setup SSL certificate key
cookbook_file '/etc/ssl/private/nginx/jira_teradici_com.key' do
  source 'jira_teradici_com.key'
  owner 'root'
  group 'root'
  mode '0600'
  action :create
end

# Generating dhparam.pem file
execute 'dhparam-generation' do
  command "openssl dhparam -out /etc/ssl/dhparam.pem 2048"
  not_if { ::File.exist?("/etc/ssl/dhparam.pem") }
  notifies :restart, 'service[nginx]', :delayed
end

# Create sites-enabled directory
directory '/etc/nginx/sites-enabled' do
  owner 'root'
  group 'root'
  mode '0700'
  action :create
  recursive true
end

# Enable Jira reverse proxy
link '/etc/nginx/sites-enabled/jira-https-proxy.conf' do
  to '/etc/nginx/sites-available/jira-https-proxy.conf'
  notifies :restart, 'service[nginx]', :delayed
  only_if 'test -f /etc/nginx/sites-available/jira-https-proxy.conf'
end

# Enable Nginx service
service 'nginx' do
  supports :status => :true, :restart => :true
  action :enable
end
