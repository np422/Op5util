# rubocop:disable LineLength, MethodLength, AbcSize, Lint/UselessAssignment
# Foo
module Op5util
  # Foo
  class Monitor
    require 'colorize'
    require 'terminfo'

    def status_host(host, options)
      full_status = JSON.parse!(get_host_status(host))
      if options[:short] || (!options[:short] && !options[:long])
        print_short_status(full_status)
      else
        print_full_status(full_status)
      end
    end

    private

    def print_short_status(full_status)
      tot_s     = full_status['num_services'].to_s
      ok_s      = full_status['num_services_hard_ok'].to_s
      mark_ok   = tot_s == ok_s
      warn_s    = full_status['num_services_hard_warn'].to_s
      mark_warn = warn_s != '0'
      crit_s    = full_status['num_services_hard_crit'].to_s
      mark_crit = crit_s != '0'
      s = "The host #{full_status['name']} is in " + host_state_to_s(full_status['state'].to_i)
      s += ' state, and it was last checked ' + pp_unixtime_ago(full_status['last_check']) + "ago.\n"
      s += 'Out of ' + tot_s.blue.bold + ' services is '
      s += pp_n_services(ok_s.to_i, tot_s.to_i) + ' in the '
      s += mark_ok ? 'OK'.green : 'OK'.red.bold
      s += + ' state, '
      s += mark_warn ? warn_s.yellow.bold : warn_s
      s += ' in the '
      s += mark_warn ? 'WARN'.yellow.bold : 'WARN'
      s += + ' state and '
      s += mark_crit ? crit_s.red.bold : crit_s
      s += ' in the '
      s += mark_crit ? 'CRIT'.red.bold : 'CRIT' + ' state'
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
      host_status = "The host #{full_status['name']} is "
      host_status += host_state_to_s full_status['hard_state']
      host_status += ', last check was done ' + pp_unixtime_ago(full_status['last_check'])
      host_status += " seconds ago.\n"
      puts host_status
      max_field_length = max_cell_width
      table = Terminal::Table.new do |t|
        t.add_row ['Service'.blue, 'State'.blue, 'Info'.blue]
        t.add_separator
        full_status['services'].each do |service|
          t.add_row [fold_string(service, max_field_length),
                     service_state_to_s(service_state(service, full_status)),
                     fold_string(service_info(service, full_status), max_field_length)]
        end
      end
      puts table
    end

    def fold_string(s, width)
      return nil if s.nil?
      start_pos = 0
      result = ''
      while start_pos < s.length
        cut_chars = [width, (s.length - start_pos)].min
        cut_pos = start_pos + cut_chars - 1
        result += s[start_pos..cut_pos]
        start_pos += cut_chars
        result += "\n" if start_pos < s.length
      end
      result
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

    def pp_n_services(n, total = 0)
      if n == total || ( total == 0 && n > 0 )
        n.to_s.green
      else
        n.to_s.red.bold
      end
    end

    def host_state_to_s(state)
      case state
      when 0
        'UP'.green
      when 1
        'DOWN'.red.bold
      else
        'UNKNOWN'.white.bold
      end
    end

    def service_state_to_s(state)
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
