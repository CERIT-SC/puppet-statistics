class statistics::database::prometheus2 {
  $flags_for_service = "--config.file /etc/prometheus/prometheus.yml --storage.tsdb.path ${::statistics::prometheus_storage} --storage.tsdb.retention.time ${::statistics::prometheus_retention_time} --web.listen-address ${::statistics::prometheus_listen_address}"
   
  file { 'config for prometheus2':
    ensure  => 'present',
    path    => '/etc/prometheus/prometheus.yml',
    content => epp('statistics/prometheus_config.epp'),
    require => Package[$::statistics::databases],
    notify  => Service['prometheus'],
  }
   
  $storage = $::statistics::prometheus_storage
  
  file { $storage:
    ensure => directory,
    group  => "prometheus",
    owner  => "prometheus",
    mode   => "0755",
  }
  
  file { 'parameters for service': 
    path    => '/etc/default/prometheus',
    content => "PROMETHEUS_OPTS=\'${flags_for_service}\'",
    ensure  => 'present',
    mode    => "0644", 
  }
  
  service { "prometheus":
    enable  => true,
    ensure  => 'running',
    require => [ File['parameters for service'], File[$storage], File["config for prometheus2"] ],
  }
}
