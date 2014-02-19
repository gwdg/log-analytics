#
class gwdg::logging::base(
  $verbose            = true,
  $public_interface   = 'eth4',
){

  Exec {
    logoutput => true,
  }

  # Get IPs dynamically from interfaces
  $facter_public_interface  = regsubst("ipaddress_${public_interface}",         '\.', '_')
  $node_public_ip           = inline_template('<%= scope.lookupvar(facter_public_interface) %>')
}
