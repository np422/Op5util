# rubocop:disable Lint/UnneededDisable
# rubocop:disable LineLength
# rubocop:disable AbcSize
# rubocop:disable SymbolArray
# rubocop:disable Metrics/MethodLength
# rubocop:disable HashSyntax

# Toplevel documentation
module Op5util
  class NoAuthMethodError < StandardError; end
  def check_authfile(file)
    authline = File.open(File.expand_path(file)).readline.chomp
  rescue StandardError
    [nil, nil]
  else
    authinfo = authline.split(':')
    authinfo.count == 2 ? authinfo : [nil, nil]
  end

  def check_auth(global_opts)
    if !global_opts[:username].nil? && !global_opts[:password].nil?
      true
    elsif !ENV['OP5USER'].nil? && !ENV['OP5PASS'].nil?
      global_opts[:username] = ENV['OP5USER']
      global_opts[:password] = ENV['OP5PASS']
      true
    elsif File.exist?(File.expand_path(global_opts[:authfile]))
      (global_opts[:username], global_opts[:password]) = check_authfile(global_opts[:authfile])
      global_opts[:username].nil? ? false : true
    else
      raise NoAuthMethodError
    end
  end

  module_function :check_auth, :check_authfile
end
