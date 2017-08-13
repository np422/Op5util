# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__), 'lib', 'op5util', 'version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'op5util'
  s.version = Op5util::VERSION
  s.author = 'Niklas Paulsson'
  s.email = 'niklasp@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A utility to do common Op5 monitoring server administion from the commandline'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc', 'op5util.rdoc']
  s.rdoc_options << '--title' << 'op5util' << '--main' << 'README.rdoc'
  s.bindir = 'bin'
  s.executables << 'op5util'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('test-unit')
  s.add_runtime_dependency('gli', '2.16.1')
  s.add_runtime_dependency('httparty', '0.15.5')
  s.add_runtime_dependency('colorize', '0.8.1')
  s.add_runtime_dependency('terminal-table', '1.8.0')
end
