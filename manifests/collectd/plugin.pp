define statistics::collectd::plugin (
   Hash    $settings = {},
   Integer $interval = 300,
) {
   file { "${statistics::path_to_plugins}/${title}.conf":
     ensure  => 'present',
     content => epp('statistics/plugin_collectd.epp', { "name" => $title, "options" => $settings, "interval" => $interval }),
     require => Package[$::statistics::type_of_probs],
     notify  => Service['collectd'],
   } 
}
