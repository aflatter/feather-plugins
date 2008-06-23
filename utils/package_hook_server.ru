require 'rubygems'
require 'rack'
require 'package_hook_server'

run PackageHookServer.new(
  :repository_path => File.join(File.dirname(__FILE__), 'repository'),
  :build_path =>      File.join(File.dirname(__FILE__), 'build')
)