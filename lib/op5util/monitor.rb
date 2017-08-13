# rubocop:disable Lint/UnneededDisable
# rubocop:disable LineLength
# rubocop:disable AbcSize
# rubocop:disable SymbolArray
# rubocop:disable Metrics/MethodLength
# rubocop:disable HashSyntax

# Top level documentation
module Op5util
  require 'httparty'
  class AuthenticationError < StandardError; end
  class CommunicationError < StandardError; end
  # Top level documentation
  class Monitor
    include HTTParty
    #debug_output $stdout

    def initialize(monitor, username, password)
      @monitor = monitor
      @auth = { username: username, password: password }
      @base_uri = "https://#{@monitor}/api/"
      url = 'status/status?format=json'
      response = self.class.get(@base_uri + url, basic_auth: @auth, verify: false)
      raise AuthenticationError if !response.nil? && !response.code.nil? && response.code == 401
      raise CommunicationError if response.nil? || response.code.nil? || response.code != 200
      self
    end
  end
end
