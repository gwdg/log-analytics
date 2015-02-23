#
class gwdg::logging::kibana(
){
  
  include gwdg::logging::base
  
  sysctl::value { "fs.file-max": value => "65536"}

  class { 'kibana3':
    config_es_server   => hiera('elasticsearch::host'),
    config_es_port     => hiera('elasticsearch::port'),
 #   config_es_protocol => 'http',
  }
}
