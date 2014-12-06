jenkins_plugin 'git'

xml_radar = File.join(Chef::Config[:file_cache_path], 'jobRadar_config.xml')

template xml_radar do
	source 'jobRadar_config.xml.erb'
end

jenkins_job 'teste_radar' do
	config xml_radar
	action :create
end	

xml_chef = File.join(Chef::Config[:file_cache_path], 'jobChef_config.xml')

template xml_chef do
	source 'jobChef_config.xml.erb'
end

jenkins_job 'teste_chef' do 
	config xml_chef
	action :create
end


jenkins_command "safe-restart" 
