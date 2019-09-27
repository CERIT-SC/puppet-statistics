class statistics::install {
  package { $::statistics::node_package:  # INSTALL ONLY COLLECTD
    ensure => 'present',
  }
}
