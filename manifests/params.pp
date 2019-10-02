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
  $databases                 = ["prometheus2"]
  $grafana_web_protocol      = "http"
  $database_path_cert_file   = undef
  $database_path_cert_key    = undef
  $influx_port               = 25800
  $influx_storage            = "/var/lib/influxdb/"
  $influx_database_name      = "collectd"
  $influx_bind_address       = "127.0.0.1:8086"
  $prometheus_storage        = "/var/lib/prometheus/data"
  $prometheus_retention_time = "15d"
  $prometheus_listen_address = "127.0.0.1:9090"

  #NODE STUFF
  $node_packages = ['collectd']
}
