class statistics::telegraf::node {
   file { 'telegraf config':
       ensure  => "present",
       path    => $::statistics::telegraf_config_path,
       mode    => "0644",
       content => epp('statistics/telegraf_config.epp', { "metric_buffer_limit" => $::statistics::telegraf_metric_buffer_limit, "options" => $::statistics::telegraf_config_options }),
       require => Package[$::statistics::type_of_probes],
       notify  => Service['telegraf'],
   }

   $::statistics::telegraf_plugins.each |$plugin| {

       statistics::telegraf::plugin { $plugin:
           settings => $plugin['settings'],
       }
   }
   
   service { 'telegraf':
      ensure  => "running",
      enable  => true,
      require => File['telegraf config'],
   }
}
