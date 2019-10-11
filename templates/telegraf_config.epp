<%- | Integer $metric_buffer_limit = 300,
      Hash    $options             = {},
| -%>
[agent]	
  metric_buffer_limit = <%= $metric_buffer_limit %>
  <% $options.each |$key, $value| { -%>
     <%= $key %> = <%= $value %>
  <% } -%>
