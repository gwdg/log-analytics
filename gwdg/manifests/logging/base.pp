#
class gwdg::logging::base(
) {

  Exec {
    logoutput => true,
  }

  # Get public IP
  $public_ip    = ip_for_network(hiera('base::network::public'))

  # Everyone also needs to be on the same clock
  class { '::ntp':
    servers     => hiera('base::ntp::servers'),
    restrict    => ['127.0.0.1'],
#    interfaces  => ['127.0.0.1', ip_for_network(hiera('openstack::network::management'))],
  }

  # Setup apt-cacher-ng (only for vagrant for now)
  if ! hiera('base::production') {
    class {'apt':
      proxy_host => 'puppetmaster.cloud.gwdg.de',
      proxy_port => '3142',
      
      # Prevent cycles in conjunction with apt::ppa
 #   } -> Package<||>
    }
  }
}
