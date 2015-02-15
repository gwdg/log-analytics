#
class gwdg::logging::elasticsearch(
  $package            = 'elasticsearch-1.4.3.deb',
  $public_interface   = 'eth4',
){
  
  include gwdg::logging::base

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup java
  class { '::java': }

  # Setup elasticsearch base
  class { '::elasticsearch':
    package_url       => "https://download.elasticsearch.org/elasticsearch/elasticsearch/${package}",
    status            => 'enabled',
    ensure            => 'present',
#    service_provider  => 'init',
   
  }

  # Setup elasticsearch instance
  elasticsearch::instance { 'es-01':
    
    status  => 'enabled',
    ensure  => 'present',
    
    # Configuration hash
    config => { 
      'cluster.name'                                    => 'es-cluster',
      'cluster.routing.allocation.awareness.attributes' => 'rack',
      'node.name'                                       => $hostname,
      'network.host'                                    => $gwdg::logging::base::node_public_ip,
#      'path.logs'                                       => '/var/log/elasticsearch',
#      'path.data'                                       => '/var/lib/elasticsearch',
    },
    
    # Init defaults hash
#   init_defaults => { },

    # Data directory
#    datadir => [ ],
  }

}
