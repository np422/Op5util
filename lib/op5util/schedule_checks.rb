# rubocop:disable LineLength, MethodLength, AccessorMethodName
# Foo
module Op5util
  # Foo
  class Monitor
    def schedule_checks(host)
      schedule_host_check(host)
      schedule_service_checks_for_host(host)
    end

    private

    def build_host_check_body(host)
      time = Time.now.to_i
      { host_name:  host,
        check_time: time }.to_json
    end

    def schedule_host_check(host)
      body = build_host_check_body(host)
      response = self.class.post(@base_uri + 'command/SCHEDULE_HOST_CHECK?format=json',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts 'Host check scheduled'
    end

    def hostgroup_services(hg)
      response = self.class.get(@base_uri + "config/hostgroup/#{URI.escape(hg)}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      hg_info = JSON.parse!(response.body)
      hg_info['services'].nil? ? [] : hg_info['services'].map { |s| s['service_description'] }
    end

    # TODO: split hostgroup_info into better re-usable code
    def service_description_for_host(host)
      response = self.class.get(@base_uri + "config/host/#{host}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      host_info = JSON.parse!(response.body)
      services = host_info['services'].map { |s| s['service_description'] }
      host_info['hostgroups'].each do |hg|
        services += hostgroup_services(hg)
      end
      services
    end

    def build_service_check_body(host, service_description)
      time = Time.now.to_i
      { host_name:           host,
        check_time:          time,
        service_description: service_description }.to_json
    end

    def schedule_service_checks_for_host(host)
      service_description_for_host(host).each do |s|
        body = build_service_check_body(host, s)
        response = self.class.post(@base_uri + 'command/SCHEDULE_SVC_CHECK?format=json',
                                   headers: { 'Content-Type' => 'application/json' },
                                   body: body, basic_auth: @auth, verify: false)
        raise ApiError unless response.code == 200
        puts "Service check for service \"#{s}\" scheduled"
      end
    end
  end
end
