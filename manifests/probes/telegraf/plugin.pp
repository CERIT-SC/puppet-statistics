define statistics::probes::telegraf::plugin (
  String  $type     = $title,
  Hash    $settings = {},
  Boolean $empty    = true,
) {
    file { "${::statistics::telegraf_path_to_plugins}/${title}.conf":
        ensure  => "present",
        mode    => "0600",
        owner   => 'telegraf',
        content => epp('statistics/plugin_telegraf.epp', { "type" => $type, "options" => $settings }),
        require => Package[$::statistics::type_of_probes],
        notify  => Service['telegraf'],
    }
}
