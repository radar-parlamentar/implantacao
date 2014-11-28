# License: GPL v3
# Author: Matheus Souza Fernandes (2014)
# Receita de instalação do SonarQube para o Radar Parlamentar

user = node['radar']['user']
home = "/home/#{user}"
repo_folder = "#{home}/radar/repo"
venv_folder = "#{home}/radar/venv_radar"


package "openjdk-7-jdk" do
  action :install
end

postgresql_database 'sonar' do
  connection(
    :host     => 'localhost',
    :port     => 5432,
    :username => 'postgres',
    :password => node['postgresql']['password']['postgres']
  )
  template 'DEFAULT'
  encoding 'DEFAULT'
  tablespace 'DEFAULT'
  connection_limit '-1'
  owner 'postgres'
  action :create
end

postgresql_connection_info = {
  :host     => 'localhost',
  :port     => node['postgresql']['config']['port'],
  :username => 'postgres',
  :password => node['postgresql']['password']['postgres']
}

postgresql_database_user node["sonar"]["user"] do
  connection postgresql_connection_info
  password node["sonar"]["password"]
  action :create
end

postgresql_database_user node["sonar"]["user"] do
  connection postgresql_connection_info
  password node["sonar"]["password"]
  database_name 'sonar'
  privileges [:all]
  action :grant
end

template "/opt/sonarqube-4.4/conf/sonar.properties" do
  mode '0644'
  source "sonar.properties.erb"
  variables({
    :user => node["sonar"]["user"],
    :password => node["sonar"]["password"],
    :port => node["sonar"]["port"]
  })
end

remote_file "/opt/sonarqube-4.4/extensions/plugins/sonar-python-plugin-1.3.jar" do
  source "http://repository.codehaus.org/org/codehaus/sonar-plugins/python/sonar-python-plugin/1.3/sonar-python-plugin-1.3.jar"
  action :create_if_missing
end


remote_file "#{home}/sonar-runner.zip" do
  source "http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip"
  action :create_if_missing
end

execute "unzip sonnar-runnser" do
  command "unzip -u sonar-runner.zip -d /opt/"
  cwd "#{home}"
  action :run
end


template "/opt/sonar-runner-2.4/conf/sonar-runner.properties" do
  mode '0644'
  source "sonar-runner.properties.erb"
  variables({
    :user => node["sonar"]["user"],
    :password => node["sonar"]["password"],
    :port => node["sonar"]["port"]
  })
end

execute "sonar-runner" do
  command ". #{venv_folder}/bin/activate && sh sonar-runner.sh"
  cwd "#{repo_folder}/radar_parlamentar/"
  action :run
end
