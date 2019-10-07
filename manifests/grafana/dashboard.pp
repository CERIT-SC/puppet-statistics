define statistics::grafana::dashboard (
  String      $url,
  String      $apikey,
  String      $name_of_dashboard = $title,
  Hash        $options           = {}, 
) { 

    $default_options = {
                         "dashboard" => {
                              "id"        => undef,
                              "uid"       => undef,
                              "title"     => "${name_of_dashboard}",
                         },
                         "folderId"  => 0,
                         "overwrite" => true,
                       }

    $options_from_user = { "dashboard" => $options }
    $merged = deep_merge($default_options, $options_from_user)

    statistics::create_dashboard($name_of_dashboard, $merged, $url, $apikey)
}
