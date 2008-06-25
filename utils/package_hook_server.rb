
# 
#  Based on
#  github_post_commit_server
#  
#  Originally created by James Tucker on 2008-05-11.
#
#  Changes for feather by Alexander Flatter <flatter@gmail.com>
# 

require 'rubygems'
require 'git'
require 'json'
require 'fileutils'
require 'extlib/assertions'
require 'extlib/hook'

class PackageHookServer
  
  include Extlib::Hook

  GO_AWAY_COMMENT = "Be gone, foul creature of the internet."
  THANK_YOU_COMMENT = "Thanks! You beautiful soul you."
  
  def initialize(options)
    @root_path = options.delete(:root_path)
    options.each_pair do |k, v|
      if [:repository_url, :repository_path, :build_path, :root_path].include?(k)
        v = File.expand_path(v, @root_path) if @root_path and k.to_s.slice(-5..-1) == '_path'
        instance_variable_set("@#{k}", v)
      else
        raise 'You need to provide :repository_path, :build_path and :repository_url'
      end
    end

    unless File.exists?(@repository_path)
      Git.clone(@repository_url, @repository_path)
    end
    unless File.exists?(@build_path)
      FileUtils.mkdir(@build_path)
    end
  end

  # This is what you get if you make a request that isn't a POST with a 
  # payload parameter.
  def rude_comment
    @res.write GO_AWAY_COMMENT
    @res.status = 404
  end
  
  # Everything is fine, be nice.
  def nice_comment
    @res.write THANK_YOU_COMMENT
  end

  # Does what it says on the tin. 
  def handle_request
    
    # Send status 404 when no payload is supplied
    payload = @req.POST["payload"]
    return rude_comment if payload.nil?
    payload = JSON.parse(payload)

    # Open git repository and pull updates
    @git = Git.open(@repository_path)
    @git.pull

    # Get plugins and package them
    stats = @git.diff(payload['before'], payload['after']).stats
    parse_stats(stats).each { |name| package_plugin(name) }
    
    # Cool, there we go
    return nice_comment

  end
  
  # Parses a Git::Diff#stats Hash and returns an Array of plugin names
  def parse_stats(stats)
    stats[:files].keys.
    select { |file| file[0..7] == 'feather-' }.
    map { |file| file.split('/').first }.uniq
  end
  
  # Execute rake task to build a package
  def package_plugin(name)
    `cd #{@repository_path}; rake feather:package path=#{name} target=#{@build_path}`
  end

  # Call is the entry point for all rack apps.
  def call(env)
    @req = Rack::Request.new(env)
    @res = Rack::Response.new
    handle_request
    @res.finish
  end

  # Hook support for the following methods
  # This allows you to subclass PackageHookServer and add hooks via after :method and before :method
  # Or via PackageHookServer.after(..) and PackageHookServer.before(..)
  register_instance_hooks :rude_comment, :nice_comment, :call, :handle_request, :package_plugin

end