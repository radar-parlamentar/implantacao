# License: GPL v3
# Author: Leonardo Leite (2015)
# Receita de instalação do SonarQube

package "openjdk-7-jdk" do
  action :install
end

include_recipe "postgresql::client"
include_recipe "postgresql::server"
include_recipe "database::postgresql"

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

postgresql_database_user node["sonarqube"]["jdbc"]["user"] do
  connection postgresql_connection_info
  password node["sonarqube"]["jdbc"]["password"]
  action :create
end

postgresql_database_user node["sonarqube"]["jdbc"]["user"] do
  connection postgresql_connection_info
  password node["sonarqube"]["jdbc"]["password"]
  database_name 'sonar'
  privileges [:all]
  action :grant
end

include_recipe "sonarqube"
