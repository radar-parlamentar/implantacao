# License: GPL v3
# Author:
# Receita de Configuração do Jenkins

user = node['radar']['user']
password = node['radar']['server_password']
home = "/home/#{user}"
venv_folder = "#{home}/radar/venv_radar"

jenkins_plugin 'git'

xml_radar = File.join(Chef::Config[:file_cache_path], 'jobRadar_config.xml')

template xml_radar do
  source 'jobRadar_config.xml.erb'
  variables ({
    :venv_folder => venv_folder
  })
end

jenkins_job 'build_radar' do
  config xml_radar
  action :create
end	

xml_chef = File.join(Chef::Config[:file_cache_path], 'jobChef_config.xml')

template xml_chef do
  source 'jobChef_config.xml.erb'
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
  config xml_chef
  action :create
end


jenkins_command "safe-restart" 
