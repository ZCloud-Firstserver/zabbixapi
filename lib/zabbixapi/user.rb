class ZabbixApi
  class User

    def initialize(options = {})
      @client = Client.new(options)
      @options = options
    end

    def create(data)
      result = @client.api_request(:method => "user.create", :params => data)
      result ? result['userids'][0].to_i : nil
    end

    def add(data)
      create(data)
    end

    def delete_by_id(data)
      result = @client.api_request(:method => "user.delete", :params => [:userid => data])
      result ? result['userids'][0].to_i : nil
    end

    def get_full_data(data)
      @client.api_request(:method => "user.get", :params => {:filter => data, :output => "extend"})
    end

    def get(data)
      get_full_data(data)
    end

    def get_id(data)
      result = get(data)
      result.empty? ? nil : result[0]['userid']
    end

    def update(data)
      result = @client.api_request(:method => "user.update", :params => data)
      result ? result['userids'][0].to_i : nil
    end

  end
end