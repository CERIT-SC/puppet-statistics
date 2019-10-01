class statistics::params  {
  
  # DEFAULT STUFF
  case $facts['operatingsystem'] {
    'Debian': {
              $collectd_config_path = "/etc/collectd/collectd.conf"
              $path_to_plugins      = "/etc/collectd/collectd.conf.d"
    }

    'CentOS': {
              $collectd_config_path = "/etc/collectd.conf"
              $path_to_plugins      = "/etc/collectd.d"
    }

    default: {
             fail("This OS is unsupported")
    }
  }

  $plugins              = []
  $collectd_listen_port = 25826
  $collectd_username    = lookup('statistics::collectd_username')
  $collectd_password    = lookup('statistics::collectd_password')
  
  # SERVER STUFF
  $server_packages           = ['grafana']
  $server                    = false
  $collectd_exp_port         = 9110
  $database                  = "prometheus2"
  $influx_port               = 25800
  $influx_storage            = "/var/lib/influxdb/"
  $influx_database_name      = "collectd"
  $prometheus_storage        = "/var/lib/prometheus/data"
  $prometheus_retention_time = "15d"

  #NODE STUFF
  $node_packages = ['collectd']
}
