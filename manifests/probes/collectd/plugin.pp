define statistics::probes::collectd::plugin (
   String  $type     = $title,
   Hash    $settings = {},
   Integer $interval = 300,
   Boolean $empty    = true,
) {
   file { "${statistics::path_to_plugins}/${title}.conf":
     ensure  => 'present',
     content => epp('statistics/plugin_collectd.epp', { "type" => $type, "options" => $settings, "interval" => $interval }),
     require => Package[$::statistics::type_of_probs],
     notify  => Service['collectd'],
   } 
}
