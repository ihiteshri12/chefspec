#
# Cookbook Name:: jira
# Recipe:: configuration
#
# Copyright (c) 2016 Teradici Corp., All Rights Reserved.

# Recipe to configure JIRA and Machine

# Setup MySQL JDBC connector for JIRA
mysql_connector_j "#{node['jira']['install_path']}/lib"

# Configuration JIRA database
template "#{node['jira']['home_path']}/dbconfig.xml" do
  source 'dbconfig.xml.erb'
  owner node['jira']['user']
  mode '0644'
  variables :database => node['jira']['database']
  notifies :restart, 'service[jira]', :delayed
end

# Setup JIRA init file
template '/etc/init.d/jira' do
  source 'jira.init.erb'
  mode '0755'
  notifies :restart, 'service[jira]', :delayed
end

# Setup JIRA application properties
template "#{node['jira']['install_path']}/atlassian-jira/WEB-INF/classes/jira-application.properties" do
  source 'jira-application.properties.erb'
  owner node['jira']['user']
  mode '0644'
  notifies :restart, 'service[jira]', :delayed
end

if Gem::Version.new(node['jira']['version']) >= Gem::Version.new('7.0.0')
  # Setup Tomcat server parameters for JIRA 7.x.x
  template "#{node['jira']['install_path']}/conf/server.xml" do
    source 'server.xml.7.erb'
    mode '0644'
    notifies :restart, 'service[jira]', :delayed
  end
else
    # Setup Tomcat server parameters for JIRA 6.x.x
  template "#{node['jira']['install_path']}/conf/server.xml" do
    source 'server.xml.6.erb'
    mode '0644'
    notifies :restart, 'service[jira]', :delayed
  end
end

# The JVM configured with the following settings in setenv.sh
ruby_block 'edit setenv.sh' do
  block do
    rc = Chef::Util::FileEdit.new("#{node['jira']['install_path']}/bin/setenv.sh")
    rc.search_file_replace_line("JVM_MINIMUM_MEMORY=\"384m\"", "JVM_MINIMUM_MEMORY=\"#{node['jira']['jvm']['minimum_memory']}\"")
    rc.write_file
  end
  not_if "grep JVM_MINIMUM_MEMORY=\\\"#{node['jira']['jvm']['minimum_memory']}\\\"  #{node['jira']['install_path']}/bin/setenv.sh"
  notifies :restart, 'service[jira]', :delayed
end

# The JVM configured with the following settings in setenv.sh
ruby_block 'edit setenv.sh' do
  block do
    rc = Chef::Util::FileEdit.new("#{node['jira']['install_path']}/bin/setenv.sh")
    rc.search_file_replace_line("JVM_MAXIMUM_MEMORY=\"768m\"", "JVM_MAXIMUM_MEMORY=\"#{node['jira']['jvm']['maximum_memory']}\"")
    rc.write_file
  end
  not_if "grep JVM_MAXIMUM_MEMORY=\\\"#{node['jira']['jvm']['maximum_memory']}\\\"  #{node['jira']['install_path']}/bin/setenv.sh"
  notifies :restart, 'service[jira]', :delayed
end

# Jira User creation
node['jira']['regular']['users'].each do |regular_user|
  user regular_user do
    comment 'jira user account'
    home "/home/#{regular_user}"
    manage_home true
    password node['jira']['regular']['password']
  end
  sudo regular_user do
    user regular_user
  end
end

# Setup JIRA cron for clean up
cron 'jira-cron' do
  hour '2'
  minute '0'
  command "root /usr/bin/find #{node['jira']['home_path']}/export/ -mtime +15 -delete"
end

service 'jira' do
  supports :status => :true, :restart => :true
  action :enable
end

# # nfs package is required to mount JIRA data directory
# package 'nfs-utils' do
#   action :install
# end
#
# # JIRA data directory
# directory node['jira']['data_path'] do
#   owner 'jira'
#   group 'jira'
#   mode  '0700'
#   action :create
#   recursive true
# end
#
# # NFS mount
# mount node['jira']['data_path'] do
#   device node['jira']['NFS']['mount_path']
#   fstype 'nfs'
#   options node['jira']['NFS']['mount_options']
#   action [:mount, :enable]
# end
