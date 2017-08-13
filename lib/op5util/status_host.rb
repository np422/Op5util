# rubocop:disable LineLength, MethodLength, AbcSize, Lint/UselessAssignment
# Foo
module Op5util
  # Foo
  class Monitor
    require 'colorize'

    def status_host(host, options)
      full_status = JSON.parse!(get_host_status(host))
      if options[:short]
        print_short_status(full_status)
      else
        print_full_status(full_status)
      end
    end

    private

    def print_short_status(full_status)
      s = "The host #{full_status['name']} is in " + state_to_s(full_status['state'].to_i)
      s += ' state, and it was last checked ' + pp_unixtime_ago(full_status['last_check']) + "ago.\n"
      s += 'Out of ' + full_status['num_services'].to_s.green + ' services is '
      s += full_status['num_services_hard_ok'].to_s.green + ' in the ' + 'OK'.green + ' state, '
      s += full_status['num_services_hard_warn'].to_s.yellow + ' in the ' + 'WARN'.yellow + ' state and '
      s += full_status['num_services_hard_crit'].to_s.red + ' in the ' + 'CRIT'.red + ' state'
      puts s
    end

    def service_state(service, full_status)
      full_status['services_with_state'].each do |s|
        return s[1] if s[0] == service
      end
      ''
    end

    def service_info(service, full_status)
      full_status['services_with_info'].each do |s|
        return s[3] if s[0] == service
      end
      ''
    end

    def print_full_status(full_status)
      table = Terminal::Table.new do |t|
        t.add_row %w[Service State Info]
        t.add_separator
        full_status['services'].each do |s|
          t.add_row [s, state_to_s(service_state(s,full_status)), service_info(s,full_status)]
        end
      end
      puts table
    end

    def pp_seconds(seconds)
      retval = ''
      s = seconds
      if s > 86_400
        retval = (s / 8600).to_s + ' days, '
        s = s % 86_400
      end
      if s > 3600
        retval += (s / 3660).to_s + ' hours, '
        s = s % 3600
      end
      if s > 60
        retval += (s / 60).to_s + ' minutes, '
        s = s % 60
      end
      retval += (s % 60).to_s + ' seconds '
    end

    def pp_unixtime_ago(t)
      pp_seconds(Time.now.to_i - t)
    end

    def state_to_s(state)
      case state
      when 0
        'OK'.green
      when 1
        'WARN'.yellow.bold
      when 2
        'CRITICAL'.red.bold
      else
        'UNKNOWN'.white.bold
      end
    end

    def get_host_status(host)
      response = self.class.get(@base_uri + "status/host/#{host}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      response.body
    end
  end
end
