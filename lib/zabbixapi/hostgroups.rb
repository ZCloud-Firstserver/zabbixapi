class ZabbixApi
  class HostGroups

    def initialize(options = {})
      @client = Client.new(options)
      @options = options
    end

    def create(data)
      result = @client.api_request(:method => "hostgroup.create", :params => [data])
      result.empty? ? nil : result['groupids'][0].to_i
    end

    def add(data)
      create(data)
    end

    def delete(data)
      result = @client.api_request(:method => "hostgroup.delete", :params => [:groupid => data])
      result.empty? ? nil : result['groupids'][0].to_i
    end

    def destroy(data)
      delete(data)
    end

    def get_full_data(data)
      @client.api_request(:method => "hostgroup.get", :params => {:filter => data, :output => "extend"})
    end

    def get_id(data)
      result = get_full_data(data)
      result.empty? ? nil : result[0]['groupid'].to_i
    end

  end
end