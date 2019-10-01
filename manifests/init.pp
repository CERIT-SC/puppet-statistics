class statistics (
  String                         $server_ip,
  Array[String]                  $server_packages           = $::statistics::params::server_packages,  
  Array[String]                  $node_packages             = $::statistics::params::node_packages,
  String                         $collectd_config_path      = $::statistics::params::collectd_config_path,
  Boolean                        $server                    = $::statistics::params::server,
  Enum['influxdb', 'prometheus'] $database                  = $::statistics::params::database,
  Integer                        $influx_port               = $::statistics::params::influx_port,
  String                         $influx_storage            = $::statistics::params::influx_storage,
  String                         $prometheus_storage        = $::statistics::params::prometheus_storage,
  String                         $prometheus_retention_time = $::statistics::params::prometheus_retention_time,
  Hash                           $plugins                   = $::statistics::params::plugins,
  Integer                        $collectd_listen_port      = $::statistics::params::collectd_port,
  Integer                        $collectd_exp_port         = $::statistics::params::collectd_exp_port,
  String                         $collectd_username         = $::statistics::params::collectd_username,
  String                         $collectd_password         = $::statistics::params::collectd_password,
) inherits statistics::params {

  contain statistics::install
  
  if ($server == true) {
    include statistics::role::server
  } else {
    include statistics::role::node
  }
}
