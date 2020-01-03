Facter.add("find_out_path_to_certs") do
  setcode do
    isInstaledLetsEncrypt = Facter::Core::Execution.exec("ls /etc/letsencrypt || echo NO")
    fqdn = Facter.value(:fqdn)
    if isInstaledLetsEncrypt == "NO"
       { "cert" => "/etc/letsencrypt/archive/#{fqdn}/fullchain1.pem", "priv" => "/etc/letsencrypt/archive/#{fqdn}/privkey1.pem" }
    else
       path_to_cert_file = Facter::Core::Execution.exec("/usr/bin/readlink -f /etc/letsencrypt/live/#{fqdn}/cert.pem")
       path_to_priv_key  = Facter::Core::Execution.exec("/usr/bin/readlink -f /etc/letsencrypt/live/#{fqdn}/privkey.pem")
       { "cert" => path_to_cert_file, "priv" => path_to_priv_key }
    end
  end
end
