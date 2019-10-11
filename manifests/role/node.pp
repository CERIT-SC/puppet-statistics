class statistics::role::node {
  if "collectd" in $::statistics::type_of_probes {
      include statistics::collectd::node
  } 
  if "telegraf" in $::statistics::type_of_probes {
      include statistics::telegraf::node
  }
}
