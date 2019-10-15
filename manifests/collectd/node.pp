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

  create_resources('statistics::collectd::plugin', $::statistics::collectd_plugins)

  service { 'collectd':
     enable  => true,
     ensure  => 'running',
     require => [ File[$::statistics::collectd_path_to_plugins], Package[$::statistics::type_of_probs], File['collectd_config'] ],
  }
}
