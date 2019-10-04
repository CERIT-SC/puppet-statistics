define statistics::grafana::dashboard (
  String      $url,
  String      $apikey,
  String      $name_of_dashboard = $title,
  Array[Hash] $panels            = [],
) {
  $data_for_api = {
                      "dashboard" => {
                           "id"        => undef,
                           "uid"       => undef,
                           "title"     => "${name_of_dashboard}",
                           "panels"    => [],
                           "folderId"  => 0,
                           "overwrite" => false,   
                       }
                  }

   $data_with_panels = $panels.reduce($data_for_api) |$memo, $value| {
        $nameOfPanel = keys($value)[0]
        $datasource  = $value[$nameOfPanel]['datasource']
        $queries = $value[$nameOfPanel]['queries'].reduce([]) |$accu, $query| {
            $memo + [{ "expr" => "${query}" }]
        }

        $memo['dashboard']['panels'] << { "id" => undef, "datasource" => $datasource, "targets" => $queries, "title" => $nameOfPanel }
   }

  statistics::create_dashboard( $name_of_dashboard, $data_with_panels, $url, $url, $apikey)
}
