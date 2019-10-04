define statistics::grafana::dashboard (
  String      $url,
  String      $apikey,
  String      $name_of_dashboard = $title,
  Hash        $panels            = {}, 
) { 

   $attribute_panels = $panels.reduce([]) |$memo, $value| {
        $nameOfPanel = $value[0]
        $datasource  = $value[1]['datasource']
        $type        = $value[1]['type']

        $queries = $value[1]['queries'].reduce([]) |$accu, $query| {
            $accu + [{ "expr" => "${query}" }]
        }

        $memo + [{ "id" => undef, "datasource" => $datasource, "targets" => $queries, "title" => $nameOfPanel, "type" => $type }]
   }   
     $data_for_api = {
                      "dashboard" => {
                           "id"        => undef,
                           "uid"       => undef,
                           "title"     => "${name_of_dashboard}",
                           "panels"    => $attribute_panels,      
                           "folderId"  => 0,
                           "overwrite" => false,
                       }
                  }

  statistics::create_dashboard( $name_of_dashboard, $data_for_api, $url, $apikey)
}
