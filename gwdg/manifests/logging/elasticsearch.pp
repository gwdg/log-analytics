#
class gwdg::logging::elasticsearch(
  $package            = 'elasticsearch-1.0.0.deb',
  $public_interface   = 'eth4',
){
  
  include gwdg::logging::base

#  sysctl::value { "fs.file-max": value => "65536"}

  # Setup java
  class { '::java': }

  # Setup elasticsearch
  class { '::elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/${package}",
    config      => {
      'cluster.name'                                    => 'es-cluster',
      'cluster.routing.allocation.awareness.attributes' => 'rack',
      'node.name'                                       => $hostname,
      'network.host'                                    => $gwdg::logging::base::node_public_ip,
#      'path.logs'                                       => '/var/log/elasticsearch',
#      'path.data'                                       => '/var/lib/elasticsearch',
    }
  }

}
