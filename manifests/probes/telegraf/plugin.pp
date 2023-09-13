define statistics::probes::telegraf::plugin (
  String  $type     = $title,
  Hash    $settings = {},
  Boolean $empty    = true,
) {
    if $facts['operatingsystem'] == 'Ubuntu' {
      $_owner = '_telegraf'
    } else {
      $_owner = 'telegraf'
    }
    file { "${::statistics::telegraf_path_to_plugins}/${title}.conf":
        ensure  => "present",
        mode    => "0600",
        owner   => $_owner,
        content => epp('statistics/plugin_telegraf.epp', { "type" => $type, "options" => $settings }),
        require => Package[$::statistics::type_of_probes],
        notify  => Service['telegraf'],
    }
}
