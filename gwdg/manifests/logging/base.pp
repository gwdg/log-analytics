#
class gwdg::logging::base(
  $verbose            = true,
  $public_interface   = 'eth4',
){

  Exec {
    logoutput => true,
  }

  # Everyone also needs to be on the same clock
  class { '::ntp':
    servers     => hiera('host::ntp::servers'),
    restrict    => ['127.0.0.1'],
#    interfaces  => ['127.0.0.1', ip_for_network(hiera('openstack::network::management'))],
  }

  # Setup apt-cacher-ng (only for vagrant for now)
  if ! hiera('production') {
    class {'apt':
      proxy_host => 'puppetmaster.cloud.gwdg.de',
      proxy_port => '3142',
    } -> Package<||>
  }

  # Get IPs dynamically from interfaces
  $facter_public_interface  = regsubst("ipaddress_${public_interface}",         '\.', '_')
  $node_public_ip           = inline_template('<%= scope.lookupvar(facter_public_interface) %>')
}
