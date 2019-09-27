class statistics::params  {
  
  # DEFAULT STUFF
  $collectd_config_path = "/etc/collectd.conf"
  $plugins              = {}
  $path_to_plugins      = "/etc/collectd.d"
  $collectd_listen_port = 25826
  
  # SERVER STUFF
  $server_packages   = ['grafana', 'collectd_exporter']
  $server            = false
  $collectd_exp_port = 9110
  $database          = "prometheus"

  #NODE STUFF
  $node_packages = ['collectd']
}
