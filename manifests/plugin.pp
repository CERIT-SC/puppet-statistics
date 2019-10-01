define statistics::plugin (
   Hash $settings = {},
) {
   file { "${statistics::path_to_plugins}/${title}.conf":
     ensure  => 'present',
     content => epp('statistics/plugin.epp', { "name" => $title, "options" => $settings }),
     require => Package['collectd'],
     notify  => Service['collectd'],
   } 
}
