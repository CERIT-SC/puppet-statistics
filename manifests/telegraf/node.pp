class statistics::telegraf::node {
   file { 'telegraf config':
       ensure  => "present",
       mode    => "0644",
       content => epp('statistics/telegraf_config_node.epp', ),
       require => Package[$::statistics::type_of_probes],
   }
   # TODO PLUGINS
   
   service { 'telegraf':
      ensure  => "running",
      enable  => true,
      require => File['telegraf config'],
   }
}
