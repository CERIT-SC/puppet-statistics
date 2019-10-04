define statistics::plugin (
   Hash    $settings = {},
   Integer $interval = 300,
) {
   file { "${statistics::path_to_plugins}/${title}.conf":
     ensure  => 'present',
     content => epp('statistics/plugin.epp', { "name" => $title, "options" => $settings, "interval" => $interval }),
     require => Package['collectd'],
     notify  => Service['collectd'],
   } 
}
