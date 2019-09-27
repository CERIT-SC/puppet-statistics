class statistics::role::node (
  Hash $plugins = $::statistics::plugins,
  String        = $::statistics::server_ip,
) {

  file { 'collectd_config': 
     ensure  => 'present',  
     path    => $::statistics::config_path,    
     content => template(''), 
     require => Package['collectd'],         
  }                                            
   
  create_resources('statistics::plugin', $plugins) 

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ Pacakage['collectd'], File['collectd_config'] ],
  }
}
