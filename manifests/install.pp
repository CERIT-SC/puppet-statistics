class statistics::install {
  package { $::statistics::type_of_probes:  # INSTALL ONLY monitoring tools
    ensure => 'present',
  }
}
