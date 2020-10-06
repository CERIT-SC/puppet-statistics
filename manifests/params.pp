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

  $cert_domains         = [$facts['fqdn']]

  #COLLECTD
  $collectd_plugins     = {}
  $collectd_listen_port = 25826
  $collectd_username    = lookup('statistics::collectd_username', undef, undef, undef)
  $collectd_password    = lookup('statistics::collectd_password', undef, undef, undef)

  # TELEGRAF
  $telegraf_config_options      = {}
  $telegraf_global_tags         = {}
  $telegraf_plugins             = []
  $telegraf_urls                = []
  $telegraf_metric_buffer_limit = 10000 
  $database_for_telegraf        = "telegraf"
  
  # SERVER STUFF
  $certs_generated_by_lets_encrypt = false
  $server_packages                 = ['grafana']
  $server                          = false
  $collectd_exp_port               = 9110
  $databases                       = ["prometheus2"]
  $grafana_web_protocol            = "http"
  $grafana_dashboards              = {}
  $grafana_url                     = "http://127.0.0.1"
  $grafana_apikey                  = "SECRET KEY"
  $grafana_plugins                 = []
  $path_to_cert_file               = undef
  $path_to_cert_key                = undef
  $influx_port                     = 25800
  $influx_storage                  = "/var/lib/influxdb/"
  $influx_collectd_database_name   = "collectd"
  $influx_bind_address             = "127.0.0.1:8086"
  $influx_auth_enabled             = false
  $influx_auth_username            = "admin"
  $influx_auth_password            = "admin"
  $influx_https                    = false
  $influx_path_to_cert             = undef
  $influx_path_to_priv_key         = undef
  $influx_additional_configuration = {}
  $backup_influxdb                 = false
  $backup_influxdb_db_name         = "telegraf"
  $backup_influxdb_path            = "/"
  $prometheus_storage              = "/var/lib/prometheus/data"
  $prometheus_retention_time       = "15d"
  $prometheus_listen_address       = "127.0.0.1:9090"

  #NODE STUFF
  $type_of_probes = ["telegraf"]
  $probes_scripts = {}
}
