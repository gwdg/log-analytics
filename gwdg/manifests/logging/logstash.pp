#
class gwdg::logging::logstash(
  $redis_port   = '6379',
  $redis_host   = $gwdg::logging::base::node_public_ip,
){
  
  include gwdg::logging::base

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup redis
  class { 'redis':
    port            => $redis_port,
    bind            => $redis_host,
    manage_repo     => true, 
    package_ensure  => '2.8.19',
  }

  # Setup java
  class { '::java': }

  # Setup logstash
  class { 'logstash':
   }

}
