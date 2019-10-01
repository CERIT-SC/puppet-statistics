class statistics::install {
  package { $::statistics::node_packages:  # INSTALL ONLY COLLECTD
    ensure => 'present',
  }
}
