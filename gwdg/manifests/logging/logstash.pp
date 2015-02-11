#
class gwdg::logging::logstash(
  $redis_port   = '6379',
  $redis_host   = $gwdg::logging::base::node_public_ip,
){
  
  include gwdg::logging::base

#  sysctl::value { "fs.file-max": value => "65536"}

  # Setup redis
  class { 'redis':
    conf_port => $redis_port,
    conf_bind => $gwdg::logging::base::node_public_ip,
  }

  # Setup java
  class { '::java': }

  # Setup logstash
  class { 'logstash':
    manage_repo     => true, 
    repo_version    => '1.3'
  }

}
