class statistics::role::node (
  Hash $plugins = $::statistics::plugins,
  String        = $::statistics::server_ip,
) {

  file { 'collectd_config': 
     ensure  => 'present',  
     path    => $::statistics::config_path,    
     content => epp('statistics/collectd_config_node.epp',{ "server_ip" => $::statistics::server_ip, "port" => $::statistics::collectd_listen_port, "username" => $::statistics::collectd_username, "password" => $::statistics::collectd_password }),
     require => Package['collectd'],         
  }                                            
   
  create_resources('statistics::plugin', $plugins) 

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ Pacakage['collectd'], File['collectd_config'] ],
  }
}
