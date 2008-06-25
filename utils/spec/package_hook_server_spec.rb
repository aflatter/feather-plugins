
require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rack/mock'
require 'rack/request'
require 'rack/response'
require 'fileutils'
require 'git'

require 'pp'; pp PackageHookServer.instance_hooks.keys

describe PackageHookServer do
  
  before(:all) do
    @temp_path = SpecHelper.generate_temp_path('repository')
    @build_path = SpecHelper.generate_temp_path('build')
    WhatEver = Hash.new
  end
  
  after(:all) do
    FileUtils.rm_rf(@temp_path)
    FileUtils.rm_rf(@build_path)
  end
  
  before(:each) do 
    @app = PackageHookServer.new(
      :repository_path => @temp_path, 
      :build_path => @build_path, 
      :repository_url => File.join(File.dirname(__FILE__), '..', '..')
    )
  end

  it 'should be a valid Rack application'

  it 'should respond with status 200 to valid requests' do
    Rack::MockRequest.new(@app).post("", :input => SpecHelper::SampleInput).should be_ok
  end
  
  it 'should respond with error 404 to invalid requests' do
    Rack::MockRequest.new(@app).get("/foo", :input => 'foo=bar&moo=mar').should be_not_found
    Rack::MockRequest.new(@app).post("").should be_not_found
  end
    
  it 'should rebuild modified plugins' do
    packages = Dir.glob(File.join(@build_path, '*.tgz')).collect { |f| File.basename(f.slice(Range.new(0, f.rindex('-') - 1))) }
    packages.should be_eql(["feather-akismet", "feather-comments", "feather-jabber", "feather-pings", "feather-redirects", "feather-repo", "feather-search", "feather-sidebar", "feather-snippets", "feather-styles", "feather-tagging", "feather-themes", "feather-twitter", "feather-uploads"])
  end
    
  it 'should parse git diff stats to an Array of plugin names' do
    @app.parse_stats(SpecHelper::SampleDiffStats).should be_eql(%w{feather-one feather-two})
  end
  
  it 'should be able to build a package'
  
  it 'should allow hooks for certain methods' do
    hookable_methods = PackageHookServer.instance_hooks.keys
    [:handle_request, :call, :package_plugin, :rude_comment, :nice_comment].each do |m|
      hookable_methods.include?(m).should be_true
    end
  end

end