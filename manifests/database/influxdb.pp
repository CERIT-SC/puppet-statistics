class statistics::databse::influxdb
{
  if $::statistics::influx_additional_configuration =~ Undef or $::statistics::influx_additional_configuration["meta"] =~ Undef or $::statistics::influx_additional_configuration["meta"]["dir"] =~ Undef {
    $storage = $::statistics::influx_storage
  } else {
    $storage = $::statistics::influx_additional_configuration["meta"]["dir"]
  }

  if $::statistics::certs_generated_by_lets_encrypt == true {
    $require = [ Exec['chown certs'], Exec['chmod priv cert'] ]
  } else {
    $require = []
  }

  $parameters_for_config = {
                              "storage"                            => $storage,
                              "influx_listening_port_for_collectd" => $::statistics::influx_port,
                              "database_name_for_collectd"         => $::statistics::influx_collectd_database_name,
                              "bind_address"                       => $::statistics::influx_bind_address,
                              "auth_enabled"                       => $::statistics::influx_auth_enabled,
                              "https"                              => $::statistics::influx_https,
                              "https_certificate"                  => $::statistics::influx_path_to_cert,
                              "https_private_key"                  => $::statistics::influx_path_to_priv_key,
                              "additional_configuration"           => $::statistics::influx_additional_configuration,
                           }
  
  file { 'config for influxdb':
    ensure  => 'present',
    path    => '/etc/influxdb/influxdb.conf',
    content => epp('statistics/influxdb_config.epp', $parameters_for_config),
    require => Package[$databases],
    notify  => Service['influxdb'],
  }

  file { $storage:
    ensure  =>  directory,
    group   => "influxdb",
    owner   => "influxdb",
    mode    =>  "0755",
  }

  service { "influxdb":
    enable  => true,
    ensure  => 'running',
    require => [ File[$storage], File["config for influxdb"] ] + $require,
  }

  if $::statistics::influx_auth_enabled == true {
    $command_options = $::statistics::influx_https ? {
       true    => "-ssl -host ${facts['fqdn']}",
       default => "",
    }

    $username        = $::statistics::influx_auth_username
    $password        = $::statistics::influx_auth_password

    exec { 'create admin account in influxdb':
      command => "/usr/bin/influx ${command_options} -username ${username} -password ${password} --execute \"CREATE USER ${username} WITH PASSWORD \'${password}\' WITH ALL PRIVILEGES\"",
      subscribe   => Service['influxdb'],
      require     => Package[$databases],
      refreshonly => true,
    }
  }
}
