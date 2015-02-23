#
class gwdg::logging::indexer(
){
  
  include gwdg::logging::base
  
  $redis_host   = $::gwdg::logging::base::public_ip
  $redis_port   = '6379'

  sysctl::value { "fs.file-max": value => "65536"}

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
  logstash::configfile { 'indexer':
    content => template('gwdg/logstash/logstash.indexer.conf.erb')
  }
}
