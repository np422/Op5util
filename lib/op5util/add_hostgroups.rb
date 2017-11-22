# rubocop:disable Lint/UnneededDisable, LineLength, AbcSize, SymbolArray, MethodLength, HashSyntax
# Foo
module Op5util
  class NoSuchHostgroupError < StandardError; end
  class NoSuchHostError < StandardError; end
  # Foo
  class Monitor
    def add_hostgroups(host, hostgroups, no_commit_config)
      hostgroups.each do |group|
        members = get_hostgroup_members(group)
        if !members.grep(host).empty?
          puts "Host #{host} is already a member of hostgroup #{group}"
        else
          raise NoSuchHostError, host unless host_exist?(host)
          members << host
          update_hostgroup(group, members)
        end
      end
      commit_op5_config unless no_commit_config
    end

    private

    def get_hostgroup_members(group)
      response = self.class.get(@base_uri + "config/hostgroup/#{group}?format=json",
                                basic_auth: @auth, verify: false)
      raise NoSuchHostgroupError if response.code == 404
      JSON.parse!(response.body)['members']
    end

    def host_exist?(host)
      response = self.class.get(@base_uri + "config/host/#{host}?format=json",
                                basic_auth: @auth, verify: false)
      raise NoSuchHostError if response.code == 404
      raise ApiError if response.code != 200
      true
    end

    def update_hostgroup(hostgroup, members)
      body = { file_id:         'etc/hostgroups.cfg',
               hostgroup_name:  hostgroup.to_s,
               members:         members }.to_json
      response = self.class.patch(@base_uri + "config/hostgroup/#{hostgroup}",
                                  headers: { 'Content-Type' => 'application/json' },
                                  body: body, basic_auth: @auth, verify: false)
      raise ApiError unless response.code == 200
    end
  end
end
