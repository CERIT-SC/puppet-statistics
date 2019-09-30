class statistics::params  {
  
  # DEFAULT STUFF
  $collectd_config_path = "/etc/collectd.conf"
  $plugins              = {}
  $path_to_plugins      = "/etc/collectd.d"
  $collectd_listen_port = 25826
  
  # SERVER STUFF
  $server_packages      = ['grafana']
  $server               = false
  $collectd_exp_port    = 9110
  $database             = "prometheus"
  $influx_port          = "25800"
  $influx_storage       = "/var/lib/influxdb/"
  $influx_database_name = "collectd"
  $prometheus_storage   = "/var/lib/prometheus/data"

  #NODE STUFF
  $node_packages = ['collectd']
}
