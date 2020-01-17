define statistics::probes::script (
  String                   $name_of_package       =  $title,
  String                   $type_of_probe         = 'telegraf',
  Hash                     $parameters_for_plugin = {},
  Variant[Integer, String] $interval_collectd     = 300,
  Pattern                  $node                  = ".*", 
) {

  if $facts['fqdn'] =~ $node {

      ensure_resource('package', $name_of_package, {'ensure' => 'present'})

      if $type_of_probe == "collectd" {

          statistics::probes::collectd::plugin { $title:
             type     => "exec",
             settings => $parameters_for_plugin,
             interval => $interval_collectd,
          }

      } elsif $type_of_probe == "telegraf" {

          statistics::probes::telegraf::plugin { $title:
             type     => "inputs.exec",
             settings => $parameters_for_plugin,
          }
      } else {
          fail("This type of probe we do not support!")
      }
  }
}
