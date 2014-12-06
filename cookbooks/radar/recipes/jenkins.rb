

xml = File.join(Chef::Config[:file_cache_path], 'jenkins_config.xml')

template xml do
	source 'jenkins_config.xml.erb'
end

jenkins_job 'radar' do
	config xml
	action :create
end	


















jenkins_command "safe-restart" 
