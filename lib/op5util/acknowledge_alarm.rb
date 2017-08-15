# rubocop:disable LineLength, AbcSize
# Foo
module Op5util
  # Foo
  class Monitor
    def acknowledge_host_alarms(host, options)
      host_states = host_status(host)
      if host_states[:host] > 0
        puts 'Acknowledge host alarm for host ' + host
        ack_host_alarm(host, options)
      else
        puts 'No alarm for host ' + host + ', not acking host'
      end
      if host_states[:services].count > 0
        host_states[:services].each do |s|
          ack_host_service(host, s, options)
          puts "Service \"#{s}\" acknowledged" if options[:verbose]
        end
        puts 'All service alarms for host ' + host + ' acknowledged'
      else
        puts "No service alarms to acknowledge for host #{host}"
      end
    end

    def acknowledge_all_alarms(options)
      response = self.class.get(@base_uri + 'config/host?format=json',
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      JSON.parse!(response.body).map { |h| h['name'] }.each do |host|
        acknowledge_host_alarms(host, options)
      end
    end

    private

    def ack_host_alarm_body(host, options)
      {
        host_name:   host,
        sticky:      true,
        notify:      true,
        persistent:  options[:persistent],
        comment:     options[:comment]
      }.to_json
    end

    def ack_host_alarm(host, options)
      body = ack_host_alarm_body(host, options)
      response = self.class.post(@base_uri + 'command/ACKNOWLEDGE_HOST_PROBLEM?format=json',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts 'Host alarm acknowledged'
    end

    def ack_host_service_alarm_body(host, service, options)
      {
        host_name:           host,
        service_description: service,
        sticky:              true,
        notify:              true,
        persistent:          options[:persistent],
        comment:             options[:comment]
      }.to_json
    end

    def ack_host_service(host, service, options)
      body = ack_host_service_alarm_body(host, service, options)
      response = self.class.post(@base_uri + 'command/ACKNOWLEDGE_SVC_PROBLEM?format=json',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts "Alarm for service \"#{service}\" acknowledged" if options[:verbose]
    end

    def host_status(host)
      response = self.class.get(@base_uri + "status/host/#{host}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      state = JSON.parse!(response.body)
      {
        host:     state['hard_state'],
        services: state['services_with_state'].select { |s| s[1] > 0 }.map { |s| s[0] }
      }
    end
  end
end
