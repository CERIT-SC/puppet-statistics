class statistics (
  String                                       $server_ip,
  Array[String]                                $server_packages                 = $::statistics::params::server_packages,  
  String                                       $collectd_config_path            = $::statistics::params::collectd_config_path,
  String                                       $collectd_path_to_plugins        = $::statistics::params::collectd_path_to_plugins,
  Boolean                                      $server                          = $::statistics::params::server,
  Array[Enum['influxdb', 'prometheus2'], 1, 2] $databases                       = $::statistics::params::databases,
  Enum['https', 'http']                        $grafana_web_protocol            = $::statistics::params::grafana_web_protocol,
  Hash                                         $grafana_dashboards              = $::statistics::params::grafana_dashboards,
  String                                       $grafana_url                     = $::statistics::params::grafana_url,
  String                                       $grafana_apikey                  = $::statistics::params::grafana_apikey,
  Array                                        $grafana_plugins                 = $::statistics::params::grafana_plugins,
  Optional[String]                             $database_path_cert_file         = $::statistics::params::database_path_cert_file,
  Optional[String]                             $database_path_cert_key          = $::statistics::params::database_path_cert_key,
  String                                       $influx_collectd_database_name   = $::statistics::params::influx_collectd_database_name,
  Integer                                      $influx_port                     = $::statistics::params::influx_port,
  String                                       $influx_storage                  = $::statistics::params::influx_storage,
  String                                       $influx_bind_address             = $::statistics::params::influx_bind_address,
  Boolean                                      $influx_auth_enabled             = $::statistics::params::influx_auth_enabled,
  String                                       $influx_auth_username            = $::statistics::params::influx_auth_username,
  String                                       $influx_auth_password            = $::statistics::params::influx_auth_password,
  Boolean                                      $influx_https                    = $::statistics::params::influx_https,
  Optional[String]                             $influx_path_to_priv_key         = $::statistics::params::influx_path_to_priv_key,
  Optional[String]                             $influx_path_to_cert             = $::statistics::params::influx_path_to_cert,
  Optional[Hash]                               $influx_additional_configuration = Undef,
  Boolean                                      $certs_generated_by_lets_encrypt = $::statistics::params::certs_generated_by_lets_encrypt,
  String                                       $prometheus_storage              = $::statistics::params::prometheus_storage,
  String                                       $prometheus_retention_time       = $::statistics::params::prometheus_retention_time,
  String                                       $prometheus_listen_address       = $::statistics::params::prometheus_listen_address,
  Array[Enum['collectd', 'telegraf'], 1, 2]    $type_of_probes                  = $::statistics::params::type_of_probes,
  Hash                                         $probes_scripts                  = lookup('statistics::probes_scripts', Hash, 'hash', $::statistics::params::probes_scripts),
  Hash                                         $telegraf_config_options         = lookup('statistics::telegraf_config_options', Hash, 'hash', $::statistics::params::telegraf_config_options),
  Hash                                         $telegraf_global_tags            = $::statistics::params::telegraf_global_tags,
  String                                       $telegraf_config_path            = $::statistics::params::telegraf_config_path,
  String                                       $telegraf_path_to_plugins        = $::statistics::params::telegraf_path_to_plugins,
  Hash                                         $telegraf_plugins                = lookup('statistics::telegraf_plugins', Hash, 'hash', $::statistics::params::telegraf_plugins),
  Array[String]                                $telegraf_urls                   = $::statistics::params::telegraf_urls,
  String                                       $database_for_telegraf           = $::statistics::params::database_for_telegraf,
  Integer                                      $telegraf_metric_buffer_limit    = $::statistics::params::telegraf_metric_buffer_limit,
  Hash                                         $collectd_plugins                = lookup('statistics::collectd_plugins', Hash, 'hash', $::statistics::params::collectd_plugins),
  Integer                                      $collectd_listen_port            = $::statistics::params::collectd_listen_port,
  Integer                                      $collectd_exp_port               = $::statistics::params::collectd_exp_port,
  String                                       $collectd_username               = $::statistics::params::collectd_username,
  String                                       $collectd_password               = $::statistics::params::collectd_password,
) inherits statistics::params {

  if ("telegraf" in $type_of_probes) and (size($databses) == 1) and ("prometheus2" in $databases) {
    fail("telegraf cannot work with prometheus. Remove telegraf from 'type_of_probes' or change databases") 
  }
  
  contain statistics::install
  
  if ($server == true) {
    include statistics::role::server
  } else {
    include statistics::role::node
  }
}
