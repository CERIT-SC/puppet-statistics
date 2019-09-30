define statistics::plugin (
   Hash $settings = {},
) {
   file {'collectd_plugin':
     ensure  => 'present',
     name    => $title,
     path    => "${::statistics::path_to_plugins}/${title}",
     content => epp('statistics/plugin.epp', {"name" => $title, "options" => $settings}),
     require => Package['collectd'],
     notify  => Service['collectd'],
   } 
}
