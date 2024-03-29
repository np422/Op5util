# rubocop:disable Lint/UnneededDisable, LineLength, AbcSize, SymbolArray, MethodLength, HashSyntax
# Foo
module Op5util
  # Foo
  class Monitor

    def schedule_downtime(host_string, options)
      host_string.split(',').each do |host|
        schedule_downtime_for_host(host, options)
      end
    end

    private

    def schedule_downtime_for_host(host, options)
      body = build_schedule_downtime_request_body(host, options)
      response = self.class.post(@base_uri + 'command/SCHEDULE_HOST_DOWNTIME',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts "Downtime Scheduled for host #{host}"
    end

    def build_schedule_downtime_request_body(host, options)
      start_time = Time.now.to_i + options[:wait].to_i
      end_time   = start_time + + options[:time].to_i * 3600 + 10
      {
        host_name:      host.to_s,
        start_time:     start_time,
        end_time:       end_time,
        fixed:          1,
        trigger_id:     0,
        duration:       options[:time].to_i * 3600 + 10,
        comment:        options[:comment]
      }.to_json
    end
  end
end
