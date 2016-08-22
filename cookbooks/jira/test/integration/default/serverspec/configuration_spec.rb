require 'spec_helper'

describe file('/var/atlassian/application-data/jira/dbconfig.xml') do
	it { should be_file }
	it { should be_owned_by 'jira' }
end

describe file('/etc/init.d/jira') do
	it { should be_file }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe file('/opt/atlassian/jira/atlassian-jira/WEB-INF/classes/jira-application.properties') do
	it { should be_file } 
	it { should be_owned_by 'jira' }
end

describe file('/opt/atlassian/jira/conf/server.xml') do
	it { should be_file }
end

describe user('bdyck') do
	it { should exist }
end

describe user('rbreckenridge') do
	it { should exist }
end

describe cron do
	it { should have entry '0 2 * * * root /usr/bin/find /var/atlassian/application-data/jira/export/ -mtime +15 -delete' }
end

describe service('jira') do
	it { should be_enabled }
	it { should be_running }
end
 
