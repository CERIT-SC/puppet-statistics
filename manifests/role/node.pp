class statistics::role::node (
  Array $plugins = $::statistics::plugins,
) {

  file { 'collectd_config': 
     ensure  => 'present',  
     path    => $::statistics::collectd_config_path,    
     content => epp('statistics/collectd_config_node.epp',{ "server_ip" => $::statistics::server_ip, "port" => $::statistics::collectd_listen_port, "username" => $::statistics::collectd_username, "password" => $::statistics::collectd_password, "dir" => $::statistics::path_to_plugins }),
     require => Package['collectd'],         
  }                                            
   
  $plugins.each |$plugin| {
    if $plugin =~ Hash {
         $name     = keys($plugin)[0]
         $settings = $plugin[$name]['settings']
     } else {
         $name     = $plugin
         $settings = {}
     }   

     statistics::plugin { $name: 
         settings => $settings,
     }   
  }

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ Package['collectd'], File['collectd_config'] ],
  }
}
