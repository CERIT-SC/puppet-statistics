class statistics (
  String        $server_ip,
  Array[String] $server_packages      = $::statistics::params::server_packages,  
  Array[String] $node_pacakges        = $::statistics::params::node_packages,
  String        $collectd_config_path = $::statistics::params::collectd_config_path,
  Boolean       $server               = $::statistics::params::server,
  Hash          $plugins              = $::statistics::params::plugins,
  Integer       $collectd_listen_port = $::statistics::params::collectd_port,
  Integer       $collectd_exp_port    = $::statistics::params::collectd_exp_port,
) inherits statistics::params {

  contain statistics::install
  
  if ($server == true) {
    include statistics::role::server
  } else {
    include statistics::role::node
  }
}
