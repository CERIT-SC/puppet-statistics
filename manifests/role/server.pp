class statistics::role::server
{
  ###### INCLUDE ALL PROBES

  if "collectd" in $::statistics::type_of_probes {
     include statistics::probes::collectd::server
  }
  if "telegraf" in $::statistics::type_of_probes {
     include statistics::probes::telegraf::server
  }

  $scripts = $::statistics::probes_scripts
  create_resources('statistics::probes::script', $scripts)

  ###### SET UP LETS ENCRYPT

  if $::statistics::certs_generated_by_lets_encrypt == true {
    class { letsencrypt:
       email  => 'root@cerit-sc.cz',
       before => File['grafana config'],
    }
        
    letsencrypt::certonly { $facts['fqdn']: 
       manage_cron => true,
       before      => File['grafana config'],
    }

    if "influxdb" in $::statistics::databases {
      $members_of_group = ["influxdb", "grafana"]
      $before           = [ Package[$::statistics::server_packages], Package[$::statistics::databases] ]
    } else {
      $members_of_group = ["grafana"]
      $before          = Package[$::statistics::server_packages]
    }

    group { 'accessToLetsEncryptCerts':
        ensure  => 'present',
        before  => $before,
    }
        
    $members_of_group.each |$member| {
        user { $member:
           ensure  => "present",
           groups  => [$member, "accessToLetsEncryptCerts"],
           require => Group['accessToLetsEncryptCerts'],
        }   
    }

    exec { 'chown certs':
       command => "/bin/chown -R grafana:accessToLetsEncryptCerts /etc/letsencrypt/archive}",
       unless  => "/usr/bin/stat -c \"%G\" /etc/letsencrypt/archive/${facts['fqdn']} | grep accessToLetsEncryptCerts",
       require => [ Group['accessToLetsEncryptCerts'], Letsencrypt::Certonly[$facts['fqdn']] ],
    }

    exec { 'chmod priv cert':
       command => "/bin/chmod 0640 /etc/letsencrypt/archive/${facts['fqdn']}/privkey1.pem",
       unless  => "/usr/bin/stat -c \"%a\" /etc/letsencrypt/archive/${facts['fqdn']}/privkey1.pem | grep 640",
       require => [ Group['accessToLetsEncryptCerts'], Letsencrypt::Certonly[$facts['fqdn']] ],
    }   
    
    $require = [ Exec['chown certs'], Exec['chmod priv cert'] ]
  } else {
    $require = []
  }

  ###### SET UP GRAFANA

  include statistics::grafana::install

  ####### SET UP DATABASES

  $databases = $::statistics::databases

  package { $databases:
    ensure => "present",
  }

  unique($databases).each |$database| { # filter duplicities
    if $database == "prometheus2" {
      include statistics::database::prometheus2    
    } elsif $database == "influxdb" {
      include statistics::database::influxdb
    } else {
      fail("Use only influxdb or prometheus2 as database")
    }
  }
}
