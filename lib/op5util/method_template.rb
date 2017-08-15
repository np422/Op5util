# rubocop:disable LineLength, MethodLength, AccessorMethodName
# Foo
module Op5util
  # Foo
  class Monitor
    def method_template
      response = self.class.get(@base_uri + 'some/path?format=json',
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts 'Do something'
    end
  end
end
