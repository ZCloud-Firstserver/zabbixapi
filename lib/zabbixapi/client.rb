require 'json'
require 'net/http'

class ZabbixApi
  class Client

    def id
      Random.rand(100000)
    end

    def api_version
      @version ||= api_request(:method => "apiinfo.version", :params => {})
    end

    def auth
      api_request(
        :method => 'user.login', 
        :params => {
          :user      => @options[:user],
          :password  => @options[:password],
        }
      )
    end

    def initialize(options = {})
      @options = options
      @auth_hash = auth
    end

    def message_json(body)
      message = {
        :method  => body[:method],
        :params  => body[:params],
        :auth    => @auth_hash,
        :id      => id,
        :jsonrpc => '2.0'
      }
      JSON.generate(message)
    end

    def http_request(body)
      uri = URI.parse(@options[:url])
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field('Content-Type', 'application/json-rpc')
      request.body = body
      response = http.request(request)
      raise "HTTP Error: #{response.code} on #{api_url}" unless response.code == "200"
      puts "[DEBUG] Get answer: #{response.body}" if @options[:debug]
      response.body
    end

    def _request(body)
      puts "[DEBUG] Send request: #{body}" if @options[:debug]
      result = JSON.parse(http_request(body))
      raise "Server answer API error: #{result['error'].inspect} on request: #{body}" if result['error']
      result['result']
    end

    def api_request(body)
      _request message_json(body)
    end

  end
end
