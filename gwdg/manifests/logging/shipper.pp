#
class gwdg::logging::shipper(
){
  
  include gwdg::logging::base

  $redis_host = hiera('redis::host')
  $redis_port = hiera('redis::port')

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup redis
  class { '::redis':

    port              => $redis_port,
    bind              => $redis_host,
    
    # Use PPA: https://launchpad.net/~chris-lea/+archive/ubuntu/redis-server
    manage_repo       => true,
    package_ensure    => hiera('redis::package_version'),
 
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
  $logstash_package         = hiera('logstash::package')
  $logstash_contrib_package = hiera('logstash::contrib_package')

  class { '::logstash':
    status              => 'enabled',
    ensure              => 'present',

    package_url         => "https://download.elasticsearch.org/logstash/logstash/packages/debian/${logstash_package}",
    
    install_contrib     => true,
    contrib_package_url => "http://download.elasticsearch.org/logstash/logstash/packages/debian/${logstash_contrib_package}",
  }

  # Setup logstash shipper (logstash -> redis)
  logstash::configfile { 'shipper':
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
