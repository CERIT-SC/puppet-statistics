<%- | String $server_ip,
      String $port,
      String $username,
      String $password,

| -%>
LoadPlugin network
<Plugin network>
        <Server "<%= $server_ip %>" "<%= $port %>">
                SecurityLevel Encrypt
                Username "<%= $username %>"
                Password "<%= $password %>"
        </Server>
</Plugin>

