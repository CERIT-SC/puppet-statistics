class statistics::role::node (
  Array $plugins = $::statistics::plugins,
) {

  file { 'collectd_config': 
     ensure  => 'present',  
     path    => $::statistics::collectd_config_path,    
     content => epp('statistics/collectd_config_node.epp',{ "server_ip" => $::statistics::server_ip, "port" => $::statistics::collectd_listen_port, "username" => $::statistics::collectd_username, "password" => $::statistics::collectd_password, "dir" => $::statistics::path_to_plugins }),
     require => Package['collectd'],         
  }
  
  file { $::statistics::path_to_plugins:
     ensure  => 'directory',
     mode    => '0644',
     require => Package['collectd'],
  }                                    
   
  $plugins.each |$plugin| {
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

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ File[$::statistics::path_to_plugins], Package['collectd'], File['collectd_config'] ],
  }
}
