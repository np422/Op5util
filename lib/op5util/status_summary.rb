# rubocop:disable LineLength, MethodLength, AccessorMethodName
# Foo
module Op5util
  require 'terminal-table'
  # Foo
  class Monitor
    def status_summary(options)
      if options[:hosts]
        print_hosts_summary
      else
        print_summary
      end
    end

    private

    def print_hosts_summary
      response = self.class.get(@base_uri + 'status/host?format=json',
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      hosts = JSON.parse!(response.body).map { |h| h['name'] }
      table = Terminal::Table.new do |t|
        t.add_row ['Host'.white, 'Host status'.white, 'Total services'.white, 'OK Services'.green, 'WARN Services'.yellow, 'CRIT Services'.red]
        t.add_separator
        hosts.each do |h|
          t.add_row row_for_host(h)
        end
      end
      puts table
    end

    def row_for_host(host)
      full_status = JSON.parse!(get_host_status(host))
      row = []
      row << host
      row << state_to_s(full_status['state'].to_i)
      row << full_status['num_services'].to_s.green
      row << full_status['num_services_hard_ok'].to_s.green
      row << full_status['num_services_hard_warn'].to_s.yellow
      row << full_status['num_services_hard_crit'].to_s.red
      row
    end

    def print_summary
      h = get_host_statuses
      s = get_service_statuses
      table = Terminal::Table.new do |t|
        t.add_row ['', 'Total'.white, 'OK'.green, 'Acknowledged problems'.yellow, 'Unhandled problems'.red]
        t.add_separator
        t.add_row ['Hosts'.white, h[0].to_s.white , count_ok(h).to_s.green, h[1].to_s.yellow, h[2].to_s.red ]
        t.add_row ['Services'.white, s[0].to_s.white , count_ok(s).to_s.green, s[1].to_s.yellow, s[2].to_s.red ]
      end
      puts table
    end

    def get_service_statuses
      service_urls = ['=%5Bservices%5D%20all',
                      '=%5Bservices%5D%20acknowledged%20%3D%201',
                      '=%5Bhosts%5D%20state%20!%3D%200%20and%20acknowledged%20%3D%200%20and%20scheduled_downtime_depth%20%3D%200']
      service_statuses = []
      service_urls.each do |url|
        response = self.class.get(@base_uri + 'filter/count?query' + url,
                                  basic_auth: @auth, verify: false)
        raise ApiError unless response.code == 200
        service_statuses << JSON.parse!(response.body)['count'].to_i
      end
      service_statuses
    end

    def count_ok(a)
      a[0] - a[1] - a[2]
    end

    def get_host_statuses
      host_urls = ['=%5Bhosts%5D%20all',
                   '=%5Bhosts%5D%20acknowledged%20%3D%201',
                   '=%5Bhosts%5D%20state%20!%3D%200%20and%20acknowledged%20%3D%200%20and%20scheduled_downtime_depth%20%3D%200']
      host_statuses = []
      host_urls.each do |url|
        response = self.class.get(@base_uri + 'filter/count?query' + url,
                                  basic_auth: @auth, verify: false)
        raise ApiError unless response.code == 200
        host_statuses << JSON.parse!(response.body)['count'].to_i
      end
      host_statuses
    end
  end
end
