require 'rest-client'
require 'json'


Puppet::Functions.create_function(:'statistics::create_dashboard') do

      dispatch :create_object do
         param 'String', :nameOfDashboard
         param 'Hash',   :arguments
         param 'String', :url
         param 'String', :apiKey
      end
    
    def create_object(nameOfDashboard, arguments, url, key)
            url += "/api/dashboards/db"
            begin
                RestClient::Request.execute(:url => url, :method => "POST", :verify_ssl => false, :timeout => 10, :payload => arguments.to_json, :headers => { "Content-Type" => "application/json", "Accept" => "application/json", "Authorization" => "Bearer #{key}"})
            rescue Errno::ECONNREFUSED => error
                return
            end
    end
    
    
    def check_if_dashboard_exists(nameOfDashboard, url, key)
         url += "/api/search"
         begin
             result = RestClient::Request.execute(:url => url, :method => "GET", :verify_ssl => false, :timeout => 10, :headers => {"Accept" => "application/json", "Authorization" => "Bearer #{key}"})
         rescue Errno::ECONNREFUSED => error
             return []
         end
         result = JSON.parse(result)
         return result.find { |dash| dash['title'] == nameOfDashboard }
    end
end
