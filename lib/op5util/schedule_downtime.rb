# rubocop:disable Lint/UnneededDisable, LineLength, AbcSize, SymbolArray, MethodLength, HashSyntax
# Foo
module Op5util
  # Foo
  class Monitor
    def schedule_downtime(host, options)
      body = build_schedule_downtime_request_body(host, options)
      response = self.class.post(@base_uri + 'command/SCHEDULE_HOST_DOWNTIME',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      puts 'Downtime Scheduled'
    end

    private

    def build_schedule_downtime_request_body(host, options)
      {
        host_name:      host.to_s,
        start_time:     Time.now.to_i,
        end_time:       Time.now.to_i + options[:time].to_i * 3600 + 10,
        fixed:          1,
        trigger_id:     0,
        duration:       options[:time].to_i * 3600 + 10,
        comment:        options[:comment]
      }.to_json
    end
  end
end
