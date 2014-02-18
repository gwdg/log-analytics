#
class gwdg::logging::elasticsearch(
#    $package    = 'elasticsearch-0.90.11.deb',
  $package            = 'elasticsearch-1.0.0.deb',
  $public_interface   = 'eth4',
){
  
  include gwdg::logging::base

  # Determine IPs from interfaces
  $facter_public_interface  = regsubst("ipaddress_${public_interface}",         '\.', '_')
  $node_public_ip           = inline_template('<%= scope.lookupvar(facter_public_interface) %>')

  sysctl::value { "fs.file-max": value => "65536"}

  # Setup java
  class { 'java': }

  # Setup elasticsearch
  class { 'elasticsearch':
    package_url => "https://download.elasticsearch.org/elasticsearch/elasticsearch/${package}",
    config      => {
      'cluster.name'                                    => 'es-cluster',
      'cluster.routing.allocation.awareness.attributes' => 'rack',
      'network.host'                                    => $node_public_ip,
    }
  }

}
