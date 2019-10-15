class statistics::role::server
{
  if "collectd" in $::statistics::type_of_probes {
     include statistics::collectd::server
  }
  if "telegraf" in $::statistics::type_of_probes {
     include statistics::telegraf::server
  }

  ###### SET UP GRAFANA

  package { $::statistics::server_packages:
    ensure => "present",
  }

  file { 'grafana config':
    ensure  => 'present',
    path    => '/etc/grafana/grafana.ini',
    content => epp('statistics/grafana_config.epp', { "protocol" => $::statistics::grafana_web_protocol, "path_to_cert_file" => $::statistics::database_path_cert_file, "path_to_cert_key" => $::statistics::database_path_cert_key }), 
    require => Package[$::statistics::server_packages],
  }


  service { 'grafana-server':
    enable  => true,
    ensure  => 'running',
    require => File['grafana config'],
  }

  $::statistics::grafana_dashboards.each |$name_of_dashboard, $dashboard| {
      statistics::grafana::dashboard { $name_of_dashboard:
          apikey  => $::statistics::grafana_apikey,
          url     => $::statistics::grafana_url,
          options => $dashboard['options'],
      }
  }
  
  $::statistics::grafana_plugins.each |$plugin| {
      statistics::grafana::plugin { $plugin: }
  }

  
  ####### SET UP DATABASES

  $databases = $::statistics::databases

  package { $databases:
   ensure => "present",
  }

  unique($databases).each |$database| { # filter duplicities

      if $database == "prometheus2" {
          
          $flags_for_service = "--config.file /etc/prometheus/prometheus.yml --storage.tsdb.path ${::statistics::prometheus_storage} --storage.tsdb.retention.time ${::statistics::prometheus_retention_time} --web.listen-address ${::statistics::prometheus_listen_address}"
     
          file { 'config for prometheus2':
            ensure  => 'present',
            path    => '/etc/prometheus/prometheus.yml',
            content => epp('statistics/prometheus_config.epp'),
            require => Package[$databases],
            notify  => Service['prometheus'],
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
            content => epp('statistics/influxdb_config.epp', { "storage" => $storage, "influx_listening_port_for_collectd" => $::statistics::influx_port, "database_name" => $::statistics::influx_database_name, "bind_address" => $::statistics::influx_bind_address, "auth_enabled" => $::statistics::influx_auth_enabled }),
            require => Package[$databases],
            notify  => Service['influxdb'],
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
            require => [ File[$storage], File["config for influxdb"] ],
          }

          if $::statistics::influx_auth_enabled == true {

              $username = $::statistics::influx_auth_username
              $password = $::statistics::influx_auth_password

              exec { 'create admin account in influxdb':
                 command => "/usr/bin/influx --execute "CREATE USER ${username} WITH PASSWORD \'${password}\' WITH ALL PRIVILEGES",
                 subscribe   => Service['influxdb'],
                 require     => Package[$databases],
                 refreshonly => true,
              }
          }
    
      } else {
          fail("Use only influxdb or prometheus2 as database")
      }
  }
}
