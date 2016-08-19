require 'chefspec'

describe 'jira::nginx' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  before do
    stub_command("test -f /etc/nginx/sites-available/jira-https-proxy.conf").and_return(true)
  end

  it 'creates a template /etc/yum.repos.d/nginx.repo' do
    expect(chef_run).to create_template('/etc/yum.repos.d/nginx.repo').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'install a package nginx' do
    expect(chef_run).to install_yum_package('nginx').with(flush_cache: {:before=>true, :after=>false})
  end

  it 'create a template /etc/nginx/nginx.conf' do
    expect(chef_run).to create_template('/etc/nginx/nginx.conf').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a directory /etc/nginx/sites-available' do
    expect(chef_run).to create_directory('/etc/nginx/sites-available').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a template /etc/nginx/sites-available/jira-https-proxy.conf' do
    expect(chef_run).to create_template('/etc/nginx/sites-available/jira-https-proxy.conf').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a directory /etc/ssl' do
    expect(chef_run).to create_directory('/etc/ssl').with(
      user: 'root',
      group: 'root',
      )
  end

  it "Creates nginx /etc/ssl/private directory" do
    expect(chef_run).to create_directory('/etc/ssl/private').with(
      user:   'root',
      group:  'root',
      mode:   '0700',
      )
  end

  it "Creates nginx /etc/ssl/private/nginx directory" do
    expect(chef_run).to create_directory('/etc/ssl/private/nginx').with(
      user:   'root',
      group:  'root',
      mode:   '0700',
      )
    end
  it 'create a file /etc/ssl/private/nginx/jira_teradici_com.crt' do
    expect(chef_run).to create_cookbook_file('/etc/ssl/private/nginx/jira_teradici_com.crt').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a file /etc/ssl/private/nginx/jira_teradici_com.key' do
    expect(chef_run).to create_cookbook_file('/etc/ssl/private/nginx/jira_teradici_com.key').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a directory /etc/nginx/sites-enabled' do
    expect(chef_run).to create_directory('/etc/nginx/sites-enabled').with(
      user: 'root',
      group: 'root',
      )
  end

  it 'create a link /etc/nginx/sites-enabled/jira-https-proxy.conf' do
    expect(chef_run).to create_link('/etc/nginx/sites-enabled/jira-https-proxy.conf').with(
      to: '/etc/nginx/sites-available/jira-https-proxy.conf'
    )
  end

  it 'restart a service nginx' do
    expect(chef_run).to enable_service('nginx')
  end

end
