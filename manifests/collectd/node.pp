class statistics::collectd::node {
  file { 'collectd_config':
     ensure  => 'present',
     path    => $::statistics::collectd_config_path,
     content => epp('statistics/collectd_config_node.epp',{ "server_ip" => $::statistics::server_ip, "port" => $::statistics::collectd_listen_port, "username" => $::statistics::collectd_username, "password" => $::statistics::collectd_password, "dir" => $::statistics::collectd_path_to_plugins }),
     require => Package[$::statistics::type_of_probs],
  }

  file { $::statistics::collectd_path_to_plugins:
     ensure  => 'directory',
     mode    => '0644',
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

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ File[$::statistics::collectd_path_to_plugins], Package[$::statistics::type_of_probs], File['collectd_config'] ],
  }
}
