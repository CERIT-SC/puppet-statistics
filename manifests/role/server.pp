class statistics::role::server
{
  $databases = $::statistics::databases

  package { $::statistics::server_packages:
    ensure => "present",
  }

  file { 'grafana config':
    ensure  => 'present',
    path    => '/etc/grafana/grafana.ini',
    content => epp('statistics/grafana_config.epp', { "protocol" => $::statistics::grafana_web_protocol, "path_to_cert_file" => $::statistics::database_path_cert_file, "path_to_cert_key" => $::statistics::database_path_cert_key }), 
    require => Package[$::statistics::server_packages],
  }
  
  package { $databases:
   ensure => "present",
  }

  $_data_for_template = { 
                          "databases"               => $databases,
                          "influxdb_port"           => $::statistics::influx_port,
                          "listen_port"             => $::statistics::collectd_listen_port,
                          "collectd_exporter_port"  => $::statistics::collectd_exp_port,
                          "dir"                     => $::statistics::path_to_plugins,
                        }

  file { 'collectd_config':
    ensure  => 'present',
    path    => $::statistics::collectd_config_path,
    content => epp('statistics/collectd_config_server.epp', $_data_for_template),
    require => Package['collectd'],
  }
  

  file { 'collectd_auth':
    ensure  => 'present',
    path    => '/etc/collectd.passwd',
    content => "${::statistics::collectd_username}: ${statistics::collectd_password}",
    require => Package['collectd'],  
  }
  
  $::statistics::plugins.each |$plugin| {
    if $plugin =~ Hash {
         $name = keys($plugin)[0]
         if has_key($plugin[$name], 'settings') {
            $settings = $plugin[$name]['settings']
         } else {
            $settings = {}
         }
         if has_key($plugin[$name], 'interval') {
            $interval = $plugin[$name]['interval']
         } else {
            $interval = 300
         }
     } else {
         $name     = $plugin
         $settings = {}
         $interval = 300
     }   

     statistics::plugin { $name:
         settings => $settings,
         interval => $interval,
     }
  }

  unique($databases).each |$database| { # filter duplicities

      if $database == "prometheus2" {
          
          $flags_for_service = "--config.file /etc/prometheus/prometheus.yml --storage.tsdb.path ${::statistics::prometheus_storage} --storage.tsdb.retention.time ${::statistics::prometheus_retention_time} --web.listen-address ${::statistics::prometheus_listen_address}"
     
          package { 'collectd_exporter':
            ensure  => "present",
          }
    
          service { 'collectd_exporter':
            enable  => true,
            ensure  => 'running',
            require => Package['collectd_exporter'],
          }
         
          file { 'config for prometheus2':
            ensure  => 'present',
            path    => '/etc/prometheus/prometheus.yml',
            content => epp('statistics/prometheus_config.epp'),
            require => Package[$databases],  
          }
     
          $storage = $::statistics::prometheus_storage
    
          file { $storage:
            ensure => directory,
            group  => "prometheus",
            owner  => "prometheus",
            mode   => "0755",
          }
          
          file { 'parameters for service': 
            path    => '/etc/default/prometheus',
            content => "PROMETHEUS_OPTS=\'${flags_for_service}\'",
            ensure  => 'present',
            mode    => "0644", 
          }
          
          service { "prometheus":
            enable  => true,
            ensure  => 'running',
            require => [ File['parameters for service'], File[$storage], File["config for ${database}"] ],
          }
    
      } elsif $database == "influxdb" {
          
          $flags_for_service = ""
          $storage = $::statistics::influx_storage
          
          file { 'config for influxdb':
            ensure  => 'present',
            path    => '/etc/influxdb/influxdb.conf',
            content => epp('statistics/influxdb_config.epp', { "storage" => $storage, "collectd_port" => $::statistics::influx_port, "database_name" => $::statistics::influx_database_name, "bind_address" => $::statistics::influx_bind_address }),
            require => Package[$databases],
          }
    
          file{ $storage:
            ensure  =>  directory,
            group   => "influxdb",
            owner   => "influxdb",
            mode    =>  "0755",
          }
    
          service { "influxdb":
            enable  => true,
            ensure  => 'running',
            flags   => $flags_for_service,
            require => [ File[$storage], File["config for ${database}"] ],
          }
    
      } else {
          fail("Use only influxdb or prometheus2 as database")
      }
  }
  
  service { 'collectd':
    enable  => true,
    ensure  => 'running',
    require => [ File['collectd_auth'], File['collectd_config'], Package['collectd'] ],
  }

  service { 'grafana-server':
    enable  => true,
    ensure  => 'running',
    require => File['grafana config'],
  }

  $::statistics::grafana_dashboards.each |$dashboard| {
      $name_of_dashboard = keys($dashboard)[0]

      statistics::grafana::dashboard { $name_of_dashboard:
          apikey => $::statistics::grafana_apikey,
          url    => $::statistics::grafana_url, 
          panels => $dashboard[$name_of_dashboard]['panels'],
      }
  }

}
