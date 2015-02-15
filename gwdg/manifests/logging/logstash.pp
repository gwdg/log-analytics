#
class gwdg::logging::logstash(
  $redis_port   = '6379',
){
  
  include gwdg::logging::base

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup redis
  class { '::redis':
    port            => $redis_port,
    bind            => $::gwdg::logging::base::public_ip,
    manage_repo     => true,
    # Use PPA: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server
    package_ensure  => '2:2.8.19-1chl1~trusty1',
  }

  # Setup java
  class { '::java': }

  # Setup logstash
#  class { 'logstash':
#   }

  # Circumvent ppa issues for redis (disabled for now)
#  package { 'software-properties-common': }
#  ->
#  exec { "add-apt-repository-${name}":
#    environment => $proxy_env,
#    command     => "/usr/bin/add-apt-repository -y ppa:chris-lea/redis-server 2>&1 > /tmp/bla.txt",
#        unless      => "/usr/bin/test -s ${sources_list_d}/${sources_list_d_filename}",
#        user        => 'root',
#        logoutput   => 'on_failure',
#    }
#  ~> Exec['apt_update'] -> Package['redis-server']

}
