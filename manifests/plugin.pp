define statistics::plugin (
   Hash $settings = {},
) {
   file {'collectd_plugin':
     ensure  => 'present',
     name    => $title,
     path    => "${::statistics::path_to_plugins}/${title}",
     content => template(''),
     require => Package['collectd'],
     notify  => Service['collectd'],
   } 
}
