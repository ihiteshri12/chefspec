# Jira database settings
default['jira']['database']['host']     = '127.0.0.1'
default['jira']['database']['name']     = 'jira'
default['jira']['database']['user']     = 'jira'
default['jira']['database']['password'] = 'changeit'

# Sets mysql root password if mysql is installed on same host
if node['jira']['database']['host'] == '127.0.0.1'
  default['mysql']['server_root_password'] = 'changethistosomethingsensible'
end

default['jira']['database']['port'] = 3306

# Default Jira URL
default['jira']['version']            = "6.4.11"
default['jira']['home_path']          = '/var/atlassian/application-data/jira'
default['jira']['install_path']       = '/opt/atlassian/jira'
default['jira']['user']               = 'jira'
default['jira']['group']              = 'jira'
default['jira']['data_path']          = '/opt/jiradata'

# Jira JVM configuration
default['jira']['jvm']['minimum_memory'] = '4g'
default['jira']['jvm']['maximum_memory'] = '4g'

# Attributes for confluence users
default['jira']['regular']['users'] = %w{bdyck rbreckenridge}
default['jira']['regular']['password'] = '$6$ePoYDlg.G$5TTtMZSbVK8jHE4nlHPpQWOSrSQK/Jg2cNBYd5YCPtDF/To3mDxzrSDom4ddApo6FdjyxWB4SLsAS1HIvCGnl/'

# JIRA server_name
default['jira']['server_name'] = 'jira.local.me'

# NFS mount
default['jira']['NFS']['mount_path'] = '10.0.80.23:/vol/vol_jira'
default['jira']['NFS']['mount_options'] = ["rsize=8192", "wsize=8192", "timeo=14", "intr"]
