# License: GPL v3
# Author:
# Receita de Configuração do Jenkins

user = node['radar']['user']
password = node['radar']['server_password']
home = "/home/#{user}"
solo_file = "#{home}/implantacao/solo.rb"
venv_folder = "#{home}/venv_jenkins"

jenkins_plugin 'git'

package "python-pip" do
  action :install
end

package "python-virtualenv" do
  action :install
end

package "libpq-dev" do
  action :install
end

package "python-dev" do
  action :install
end

python_virtualenv "#{venv_folder}" do
  owner 'jenkins'
  group 'jenkins'
  action :create
end

xml_build = File.join(Chef::Config[:file_cache_path], 'jobRadar_config.xml')

template xml_build do
  source 'jobBuildRadar_config.xml.erb'
  variables ({
    :venv_folder => venv_folder
  })
end

jenkins_job 'build_radar' do
  config xml_build
  action :create
end	

xml_deploy = File.join(Chef::Config[:file_cache_path], 'jobDeployRadar_config.xml')

template xml_deploy do
  source 'jobDeployRadar_config.xml.erb'
  variables ({
    :home => home,
    :venv_folder => venv_folder,
    :user => user,
    :solo_file => solo_file
  })
end

jenkins_job 'deploy_radar' do 
  config xml_deploy
  action :create
end

# make jenkins sudo without password
template '/etc/sudoers' do
  source 'sudoers.erb'
end

jenkins_command "safe-restart" 

