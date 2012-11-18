class ZabbixApi
  class Templates

    def initialize(options = {})
      @client = Client.new(options)
      @options = options
    end

    def create(data)
      result = @client.api_request(:method => "template.create", :params => [data])
      result.empty? ? nil : result['templateids'][0].to_i
    end

    def add(data)
      create(data)
    end

    def delete(data)
      result = @client.api_request(:method => "template.delete", :params => [:templateid => data])
      result.empty? ? nil : result['templateids'][0].to_i
    end

    def destroy(data)
      delete(data)
    end

    def get_ids_by_host(data)
      result = []
      @client.api_request(:method => "template.get", :params => data).each do |tmpl|
        result << tmpl['templateid']
      end
      result
    end

    def link_with_host(data)
      result = @client.api_request(
        :method => "template.massAdd", 
        :params => {
          :hosts => data[:hosts_id].map { |t| {"hostid" => t} },
          :templates => data[:templates_id].map { |t| {"templateid" => t} }
        }
      )
      result.empty? ? false : true
    end

    def all
      result = {}
      @client.api_request(:method => "template.get", :params => {:output => "extend"}).each do |tmpl|
        result[tmpl['host']] = tmpl['hostid']
      end
      result
    end

    def get_full_data(data)
      @client.api_request(:method => "template.get", :params => {:filter => data, :output => "extend"})
    end

    def get_id(data)
      result = get_full_data(data)
      result.empty? ? nil : result[0]['templateid'].to_i
    end

  end
end