class statistics::params  {
  
  # DEFAULT STUFF
  case $facts['operatingsystem'] {
    'Debian': {
              $collectd_config_path     = "/etc/collectd/collectd.conf"
              $collectd_path_to_plugins = "/etc/collectd/collectd.conf.d"
              $telegraf_path_to_plugins = "/etc/telegraf/telegraf.d"
              $telegraf_config_path     = "/etc/telegraf/telegraf.conf"
    }

    'CentOS', 'RedHat': {
              $collectd_config_path     = "/etc/collectd.conf"
              $collectd_path_to_plugins = "/etc/collectd.d"
              $telegraf_path_to_plugins = "/etc/telegraf/telegraf.d"
              $telegraf_config_path     = "/etc/telegraf/telegraf.conf"

    }

    default: {
             fail("This OS is unsupported")
    }
  }

  #COLLECTD
  $collectd_plugins     = []
  $collectd_listen_port = 25826
  $collectd_username    = lookup('statistics::collectd_username')
  $collectd_password    = lookup('statistics::collectd_password')

  # TELEGRAF
  $telegraf_config_options      = {}
  $telegraf_plugins             = []
  $telegraf_urls                = []
  $telegraf_metric_buffer_limit = 10000 
  $database_for_telegraf        = "telegraf"
  
  # SERVER STUFF
  $server_packages           = ['grafana']
  $server                    = false
  $collectd_exp_port         = 9110
  $databases                 = ["prometheus2"]
  $grafana_web_protocol      = "http"
  $grafana_dashboards        = {}
  $grafana_url               = "http://127.0.0.1"
  $grafana_apikey            = "SECRET KEY"
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
  $type_of_probes = ["telegraf"]
}
