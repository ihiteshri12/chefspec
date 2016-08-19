#
# Cookbook Name:: jira
# Recipe:: installer
#
# Copyright (c) 2016 Teradici Corp., All Rights Reserved.
# Recipe to install JIRA

# JIRA URL to download
if Gem::Version.new(node['jira']['version']) >= Gem::Version.new('7.0.0')
  jira_url = "https://downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-#{node['jira']['version']}-jira-#{node['jira']['version']}-x64.bin"
else
  jira_url = "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-#{node['jira']['version']}-x64.bin"
end

# Write variable file which used during JIRA installation
template "#{Chef::Config[:file_cache_path]}/atlassian-jira-response.varfile" do
  source 'response.varfile.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    'update' => Dir.exist?(node['jira']['install_path'])
  )
end

# Download JIRA from jira_url
remote_file "#{Chef::Config[:file_cache_path]}/atlassian-jira-#{node['jira']['version']}.bin" do
  source jira_url
  mode '0755'
  action :create
  not_if { ::File.exist?("#{node['jira']['install_path']}/bin/jira-configurator.jar") }
end

# Install JIRA
execute "Installing Jira #{node['jira']['version']}" do
  cwd Chef::Config[:file_cache_path]
  command "./atlassian-jira-#{node['jira']['version']}.bin -q -varfile atlassian-jira-response.varfile"
  not_if { ::File.exist?("#{node['jira']['install_path']}/bin/jira-configurator.jar") }
end
