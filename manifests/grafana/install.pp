class statistics::grafana::install {
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
    require => File['grafana config'] + $require,
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
}
