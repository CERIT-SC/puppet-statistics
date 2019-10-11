class statistics::telegraf::server {
   file { 'telegraf config':
       ensure  => "present",
       mode    => "0644",
       content => epp('statistics/telegraf_config_server.epp', ),
       require => Package[$::statistics::type_of_probes],
   }
   # TODO PLUGINS

   service { 'telegraf':
      ensure  => "running",
      enable  => true,
      require => File['telegraf config'],
   }
}
