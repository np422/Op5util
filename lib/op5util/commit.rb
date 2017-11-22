module Op5util
  require 'resolv'
  class ApiError < StandardError; end
  # Foo
  class Monitor
    def commit_op5_config
      if pending_changes.empty?
        puts 'No changes to commit'
      else
        do_commit
      end
    end

    private

    def pending_changes
      url = @base_uri + 'config/change'
      response = self.class.get(url, basic_auth: @auth, verify: false)
      raise ApiError, "Response code: #{response.code}, Message: #{response.body}" if response.code != 200
      JSON.parse!(response.body)
    end

    def do_commit
      url = @base_uri + 'config/change'
      response = self.class.post(url, body: {}, basic_auth: @auth, verify: false)
      raise ApiError, "Response code: #{response.code}, Message: #{response.body}" if response.code != 200
      puts 'Op5-config commited'
    end

  end
end
