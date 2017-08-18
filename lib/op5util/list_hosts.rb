# rubocop:disable LineLength, AbcSize
# Foo
module Op5util
  # Foo
  class Monitor
    def list_hosts(host, options)
      response = self.class.get(@base_uri + 'config/host?format=json',
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      JSON.parse!(response.body).map { |h| h['name'] }.select { |h| host.nil? ? true : h == host }.each do |h|
        puts h
        print_detailed_host_info(h) if options[:long]
      end
    end

    private

    def print_detailed_host_info(host)
      response = self.class.get(@base_uri + "config/host/#{host}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      host_info = JSON.parse!(response.body)
      puts 'Contact-groups: ' + host_info['contact_groups'].join(',')
      puts 'Host-groups: ' + host_info['hostgroups'].join(',')
      puts 'Address: ' + host_info['address']
      puts 'Alias: ' + host_info['alias']
    end
  end
end
