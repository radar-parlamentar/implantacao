# License: GPL v3
# Author:
# Receita de Configuração do Jenkins

user = node['radar']['user']
password = node['radar']['server_password']
home = "/home/#{user}"
venv_folder = "#{home}/venv_jenkins"

jenkins_plugin 'git'

package "python-pip" do
  action :install
end

package "python-virtualenv" do
  action :install
end

python_virtualenv "#{venv_folder}" do
  owner user
  group user
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
    :venv_folder => venv_folder
  })
end

python_pip "fabric" do
  virtualenv "#{venv_folder}"
end

template "#{home}/fabfile.py" do
  source "fabfile.py.erb"
  variables ({
    :user => user,
    :password => password,
    :home => home
  })
end


jenkins_job 'deploy_radar' do 
  config xml_deploy
  action :create
end


jenkins_command "safe-restart" 
