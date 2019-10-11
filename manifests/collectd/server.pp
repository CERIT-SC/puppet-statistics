class statistics::collectd::server {
  $_data_for_template = {
                          "databases"               => $::statistics::databases,
                          "influxdb_port"           => $::statistics::influx_port,
                          "listen_port"             => $::statistics::collectd_listen_port,
                          "collectd_exporter_port"  => $::statistics::collectd_exp_port,
                          "dir"                     => $::statistics::collectd_path_to_plugins,
                        }

  file { 'collectd_config':
    ensure  => 'present',
    path    => $::statistics::collectd_config_path,
    content => epp('statistics/collectd_config_server.epp', $_data_for_template),
    require => Package[$::statistics::type_of_probs],
  }


  file { 'collectd_auth':
    ensure  => 'present',
    path    => '/etc/collectd.passwd',
    content => "${::statistics::collectd_username}: ${statistics::collectd_password}",
    require => Package[$::statistics::type_of_probs],
  }

  $::statistics::collectd_plugins.each |$plugin| {
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

     statistics::collectd::plugin { $name:
         settings => $settings,
         interval => $interval,
     }
  }

  if ("prometheus2" in $::statistics::databases) {
     package { 'collectd_exporter':
         ensure  => "present",
     }

     service { 'collectd_exporter':
         enable  => true,
         ensure  => 'running',
         require => Package['collectd_exporter'],
     }
  }
  
  service { 'collectd':
    enable  => true,
    ensure  => 'running',
    require => [ File['collectd_auth'], File['collectd_config'], Package[$::statistics::type_of_probs] ],
  }
}
