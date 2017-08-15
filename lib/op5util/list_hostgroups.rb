# rubocop:disable LineLength, MethodLength, AbcSize
# Foo
module Op5util
  # Foo
  class Monitor
    def list_hostgroups(options)
      response = self.class.get(@base_uri + 'config/hostgroup?format=json',
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      hostgroups = JSON.parse!(response.body).map { |h| h['name'] }
      if options[:long]
        list_hostgroups_with_services(hostgroups)
      else
        hostgroups.each { |h| puts h }
      end
    end

    private

    def hostgroup_info(h)
      response = self.class.get(@base_uri + "config/hostgroup/#{URI.escape(h)}?format=json",
                                basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
      hostgroup = JSON.parse!(response.body)
      hostgroup['members'].nil? ? '' : members = hostgroup['members'].join(',')
      hostgroup['services'].nil? ? '' : services = hostgroup['services'].map { |s| '"' + s['service_description'] + '"' }.join(',')
      [members, services]
    end

    def max_cell_width
      # The magic number 15 is the size of tables cells padding + the heading 'State'
      # and a an extra characters for safe layout on narrow terminals, down to
      # 80 characters width tested.
      terminal_width = TermInfo.screen_size[1]
      ((terminal_width - 15) / 2).floor
    end

    def list_hostgroups_with_services(hostgroups)
      max = max_cell_width
      table = Terminal::Table.new do |t|
        t.add_row ['Hostgroup'.blue, 'Member hosts'.blue, 'Service checks'.blue]
        t.add_separator
        hostgroups.each do |h|
          (members, services) = hostgroup_info(h)
          t.add_row [h, fold_string(members, max), fold_string(services, max)]
        end
      end
      puts table
    end
  end
end
