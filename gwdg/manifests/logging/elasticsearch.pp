#
class gwdg::logging::elasticsearch(
){
  
  include gwdg::logging::base

  $package = hiera('elasticsearch::package')

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup java
  class { '::java': }

  # Setup elasticsearch base
  class { '::elasticsearch':
    package_url       => "https://download.elasticsearch.org/elasticsearch/elasticsearch/${package}",
    status            => 'enabled',
    ensure            => 'present',
    autoupgrade       => true,
#    service_provider  => 'init',   
  }

  # Setup elasticsearch instance
  elasticsearch::instance { 'es-01':
    
    status  => 'enabled',
    ensure  => 'present',
    
    # Configuration hash
    config => { 
      'cluster.name'                                    => hiera('elasticsearch::cluster::name'),
      'cluster.routing.allocation.awareness.attributes' => 'rack',
      'node.name'                                       => $hostname,
      'network.host'                                    => $gwdg::logging::base::public_ip,

      # Needed for Kibana
      'http.cors.enabled'                               => true,
      'http.cors.allow-origin'                          => '/.*/',  
    
#      'path.logs'                                       => '/var/log/elasticsearch',
#      'path.data'                                       => '/var/lib/elasticsearch',
    },
    
    # Init defaults hash
#   init_defaults => { },

    # Data directory
#    datadir => [ ],
  }

}
