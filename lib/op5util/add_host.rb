# rubocop:disable Lint/UnneededDisable
# rubocop:disable LineLength
# rubocop:disable AbcSize
# rubocop:disable SymbolArray
# rubocop:disable Metrics/MethodLength
# rubocop:disable HashSyntax
# Foo
module Op5util
  require 'resolv'
  class ApiError < StandardError; end
  # Foo
  class Monitor
    def add_host(host, options)
      body = build_add_host_request_body(host, options)
      response = self.class.post(@base_uri + 'config/host',
                                 headers: { 'Content-Type' => 'application/json' },
                                 body: body, basic_auth: @auth, verify: false)
      raise ApiError, "Response code: #{response.code}, Message: #{response.body}" if response.code != 201
      puts 'New host created'

      url = @base_uri + 'config/change'
      response = self.class.post(url, body: {}, basic_auth: @auth, verify: false)
      raise ApiError, "Response code: #{response.code}, Message: #{response.body}" if response.code != 200
      puts 'New op5-config saved'
    end

    private

    def build_add_host_requst_body(host, options)
      host_ipaddr   = options[:ipaddr].nil? ? Resolv.getaddress(host) : options[:ipaddr]
      host_alias    = options[:alias].nil? ? short_name(host) : options[:alias]
      contactgroups = options[:contactgroups].nil? ? ['support-group'] : options[:contactgroups]
      hostgroups    = options[:hostgroups].nil? ? [] : options[:hostgroups]
      add_host_request_body_as_json(host, host_ipaddr, host_alias, contactgroups, hostgroups)
    end

    def add_host_request_body_as_json(host, host_ipaddr, host_alias, contactgroups, hostgroups)
      { file_id:                   'etc/hosts.cfg',
        host_name:                 host.to_s,
        address:                   host_ipaddr.to_s,
        alias:                     host_alias.to_s,
        max_check_attempts:        3,
        notification_interval:     0,
        notification_options:      %w[d u r],
        notification_period:       '24x7',
        notifications_enabled:     true,
        template:                  'default-host-template',
        contact_groups:            contactgroups,
        hostgroups:                hostgroups }.to_json
    end

    def short_name(h)
      split_host = h.split('.')
      if split_host.count > 1
        split_host[0]
      else
        ''
      end
    end
  end
end
