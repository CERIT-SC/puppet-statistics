class statistics::grafana::install {
  package { $::statistics::server_packages:
    ensure => "present",
  } 
  
  file { 'grafana config':
    ensure  => 'present',
    path    => '/etc/grafana/grafana.ini',
    content => epp('statistics/grafana_config.epp', { "protocol" => $::statistics::grafana_web_protocol, "path_to_cert_file" => $::statistics::path_to_cert_file, "path_to_cert_key" => $::statistics::path_to_priv_cert }), 
    require => Package[$::statistics::server_packages],
  }

  if  $::statistics::certs_generated_by_lets_encrypt == true {
    $require = [ Exec['chown certs'], Exec['chmod priv cert'] ]
  } else {
    $require = []
  }

  service { 'grafana-server':
    enable  => true,
    ensure  => 'running',
    require => [File['grafana config']] + $require,
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
