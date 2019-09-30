class statistics::role::server
{
  package { $::statistics::server_packages :
    ensure => "present",
  }
  
  package { 'database for grafana':
   name   => $database.
   ensure => "present",
  }

  $_data_for_template = { 
                          "database"               => $::statistics::database,
                          "influx_port"            => $::statistics::influx_port,
                          "listen_port"            => $::statistics::collectd_listen_port,
                          "collectd_exporter_port" => $::statistics::collectd_exp_port,
                        }

  file { 'collectd_config':
    ensure  => 'present',
    path    => $::statistics::config_path,
    content => epp('statistics/collectd_config_server.epp', $_data_for_template),
    require => Package['collectd'],
  }
  

  file { 'collectd_auth':
    ensure  => 'present',
    path    => '/etc/collectd.passwd'
    content => "${::statistics::collectd_username}: ${statistics::collectd_password}",
    require => Package['collectd'],  
  }

  create_resources("statistics::plugin", $plugins)

  if $::statistics::database == "prometheus" {
      package { 'collectd_exporter':
        ensure  => "present",
      }

      service { 'collectd_exporter':
        enable  => true,
        ensure  => 'running',
        require => Package['collectd_exporter'],
      }
     
      file { 'config for prometheus':
        ensure  => 'present',
        path    => '/etc/prometheus/prometheus.yml',
        content => epp('statistics/prometheus_config.epp'),
        require => Package['database for grafana'],  
      }
  } elsif $::statistics::database == "influxdb" {
      file { 'config for influxdb':
        ensure  => 'present',
        path    => '/etc/influxdb/influxdb.conf',
        content => epp('statistics/influxdb_config.epp', { "dir" => $::statistics::influx_storage, "collectd_port" => $::statistics::influx_port, "database_name" => $::statistics::influx_database_name }),
        require => Package['database for grafana'],
      }
  } else {
      fail("Use only influxdb or prometheus as database")
  }
  
  service { 'collectd':
    enable  => true,
    ensure  => 'running',
    require => [ File['collectd_auth'], File['collectd_config'], Package['collectd'] ],
  }

  service { $database:
    enable  => true,
    ensure  => 'running',
    require => File["config for ${database}"],
  }
  
  service { 'grafana':
    enable  => true,
    ensure  => 'running',
    require => Service[$database],
  }
}
