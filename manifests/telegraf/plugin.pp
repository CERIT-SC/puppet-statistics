define statistics::telegraf::plugin (
  Hash $settings => {},
) {
    file { "${::statistics::telegraf_path_to_plugins}/${title}.conf":
        ensure  => "present",
        mode    => "0644",
        content => epp('statistics/plugin_telegraf.epp', { "name" => $title, "options" => $settings }),
        require => Package[$::statistics::type_of_probes],
        notify  => Service['telegraf'],
    }
}
