define statistics::grafana::plugin {
  exec { "install plugin ${title}":
      command => "/usr/sbin/grafana-cli plugins install ${title}",
      unless  => "/usr/sbin/grafana-cli plugins ls | /usr/bin/grep ${title}",
      notify  => Service['grafana-server'],
  }
}
