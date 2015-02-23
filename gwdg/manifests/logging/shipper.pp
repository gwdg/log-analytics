#
class gwdg::logging::logstash(
){
  
  include gwdg::logging::base
  
  $redis_host   = $::gwdg::logging::base::public_ip
  $redis_port   = '6379'

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup redis
  class { '::redis':
    port              => $redis_port,
    bind              => $redis_host,
    
    # Use PPA: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server
    manage_repo       => true,
    package_ensure    => '2:2.8.19-1chl1~trusty1',
 
    # Commit to append log every second
    appendfsync       => 'everysec',

    # Disable RBD?
    appendonly        => false,
    
    # Log level
    log_level         => 'notice',

    # Maximum memory
    maxmemory         => undef,
    
    # Maxmemory policy
    maxmemory_policy  => undef,
  }

  # Setup java
  class { '::java': } -> Package['logstash']

  # https://download.elasticsearch.org/logstash/logstash/packages/debian/logstash-contrib_1.4.2-1-efd53ef_all.deb
  # Setup logstash
  $logstash_package         = 'logstash_1.4.2-1-2c0f5a1_all.deb'
  $logstash_contrib_package = 'logstash-contrib_1.4.2-1-efd53ef_all.deb'

  class { '::logstash':
    status              => 'enabled',
    ensure              => 'present',

    package_url         => "https://download.elasticsearch.org/logstash/logstash/packages/debian/${logstash_package}",
    
    install_contrib     => true,
    contrib_package_url => "http://download.elasticsearch.org/logstash/logstash/packages/debian/${logstash_contrib_package}",
  }

  # Setup logstash shipper (logstash -> redis)
  logstash::configfile { 'configname':
    content => template('gwdg/logstash/logstash.shipper.conf.erb')
  }

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
