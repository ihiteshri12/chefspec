require 'spec_helper'

describe file('/etc/yum.repos.d/nginx.repo') do
	it { should be_file }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe package('nginx') do
	it { should be_installed }
end

describe file('/etc/nginx/nginx.conf') do
	it { should be_file }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe file('/etc/nginx/sites-available') do
	it { should be_directory }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe file('/etc/nginx/sites-available/jira-https-proxy.conf') do	
	 it { should be_file }
         it { should be_owned_by 'root' }
         it { should be_grouped_into 'root' }
end

describe file('/etc/ssl/private/nginx') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

file('/etc/ssl/private/nginx/jira_teradici_com.crt') do
	it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
end

describe file('/etc/ssl/private/nginx/jira_teradici_com.key') do
	it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
end

describe file('/etc/nginx/sites-enabled') do
	it { should be_directory }
	it { should be_owned_by 'root' }
	it { should be_grouped_into 'root' }
end

describe file('/etc/nginx/sites-enabled/jira-https-proxy.conf') do
	it { should be_linked_to '/etc/nginx/sites-available/jira-https-proxy.conf' }
end

describe service('nginx') do
	it { should be_running }
end


