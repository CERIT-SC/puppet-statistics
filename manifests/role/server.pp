class statistics::node::server (
  Hash $plugins = $::statistics::plugins,
) {
  
  package { $::statistics::server_packages :
    ensure => "present",
  }
  
  file { 'collectd_config':
    ensure  => 'present',
    path    => $::statistics::config_path,
    content => template(''),
    require => Package['collectd'],
  }
  
  create_resources("statistics::plugin", $plugins)
  
  service {'collectd':
    enable  => true,
    ensure  => 'running',
    require => [ File['collectd_config'] ,Package['collectd'] ],
  }

  service { 'collectd_exp':
    name    => 'collectd_exporter',
    enable  => true,
    ensure  => 'running',
    require => [ File['collectd_config'] ,Package['collectd_exporter'] ],
  }
 
  # TODO NASTAVIT CONFIG DATABAZY AND GRAFANY
  # TODO RUN GRAFANA AND PROMETHEUS
}
