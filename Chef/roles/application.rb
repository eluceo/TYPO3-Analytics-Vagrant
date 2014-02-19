name "application"
description "The application role. Installs the required application stack"

run_list "recipe[supervisor]",
		 "recipe[rabbitmq]",
		 "recipe[rabbitmq::mgmt_console]",
		 "recipe[rabbitmq::virtualhost_management]",
		 "recipe[rabbitmq::user_management]",
		 "recipe[typo3analytics]",
		 "recipe[repositoryhandler]",
		 "recipe[cvsanaly]",
		 "recipe[github-linguist]"

override_attributes(
	:supervisor => {
		:inet_port => "192.168.33.55:9001",
		:inet_username => "analysis",
		:inet_password => "analysis"
	},
	:rabbitmq => {
		:version => '3.2.3',
		:address => '192.168.33.55',
		:virtualhosts => ['analysis'],
		:enabled_users => [{
			:name => "analysis",
			:password => "analysis",
			:tag => 'administrator',
			:rights => [{
				:vhost => 'analysis' ,
				:conf => ".*",
				:write => ".*",
				:read => ".*"
			}],
		}],
		:disabled_users => ['guest']
	},
	:repositoryhandler => {
		:destination => '/var/www/analysis/tools/MetricsGrimoire/RepositoryHandler'
	},
	:cvsanaly => {
		:destination => '/var/www/analysis/tools/MetricsGrimoire/CVSAnalY'
	},
	:github_linguist => {
		:install_method => "source",
		:path => "/var/www/analysis/tools/github-linguist"
	}
)