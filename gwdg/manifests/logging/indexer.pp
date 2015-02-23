#
class gwdg::logging::indexer(
){
  
  include gwdg::logging::base
  
  $redis_host = hiera('redis::host')
  $redis_port = hiera('redis::port')
  
  $elasticsearch_host = hiera('elasticsearch::host')
  $elasticsearch_port = hiera('elasticsearch::port')

  sysctl::value { "fs.file-max": value => "65536"}

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
  logstash::configfile { 'indexer':
    content => template('gwdg/logstash/logstash.indexer.conf.erb')
  }
}
