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

}
