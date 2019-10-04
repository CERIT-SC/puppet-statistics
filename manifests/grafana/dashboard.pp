define statistics::grafana::dashboard (
  String      $url,
  String      $apikey,
  String      $name_of_dashboard = $title,
  Hash        $panels            = {}, 
) { 

   $attribute_panels = $panels.reduce([]) |$memo, $value| {
        $nameOfPanel = $value[0]
        $datasource  = $value[1]['datasource']
        
        if has_key($value[1], 'type') {
            $type = $value[1]['type']
        } else {
            $type = "graph"
        }

        if has_key($value[1], 'legend') {
            $legend = $value[1]['legend']
        } else {
            $legend = {}
        }

        $queries = $value[1]['queries'].reduce([]) |$accu, $query| {
            if $query =~ Hash {
                $name_of_query = keys($query)[0]
                $accu + [{ "legendFormat" => $query[$name_of_query]['label'], "expr" => $name_of_query }]
            } else {
                $accu + [{ "expr" => "${query}" }]
            }
        }


        if has_key($value[1], 'yaxes') {
            $yaxes = $value[1]['yaxes']
            $memo + [{ "id" => undef, "datasource" => $datasource, "targets" => $queries, "title" => $nameOfPanel, "type" => $type, "legend" => $legend, "yaxes" => $yaxes, "xaxis" => {"show" => true}}]
        } else {
            $yaxes = []
            $memo + [{ "id" => undef, "datasource" => $datasource, "targets" => $queries, "title" => $nameOfPanel, "type" => $type, "legend" => $legend }]
        }
        
        $memo + [{ "id" => undef, "datasource" => $datasource, "targets" => $queries, "title" => $nameOfPanel, "type" => $type, "legend" => $legend, "yaxes" => $yaxes }]
   }   
     $data_for_api = {
                      "dashboard" => {
                           "id"        => undef,
                           "uid"       => undef,
                           "title"     => "${name_of_dashboard}",
                           "panels"    => $attribute_panels,      
                       },
                           "folderId"  => 0,
                           "overwrite" => true,
                  }

  statistics::create_dashboard( $name_of_dashboard, $data_for_api, $url, $apikey)
}
