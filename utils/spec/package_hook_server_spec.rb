
require File.join(File.dirname(__FILE__), 'spec_helper')

require 'rack/mock'
require 'rack/request'
require 'rack/response'
require 'fileutils'
require 'git'

describe PackageHookServer do
  
  before(:all) do
    @temp_path = SpecHelper.generate_temp_path
    @build_path = SpecHelper.generate_temp_path
    @git = Git.clone(SpecHelper::SampleRepositoryPath, @temp_path)
  end
  
  after(:all) do
    FileUtils.rm_rf(@temp_path)
  end
  
  before(:each) do 
    @app = PackageHookServer.new(:repository_path => @temp_path, :build_path => @build_path)
  end

  it 'should be a valid Rack application'

  it 'should respond with status 200 to valid requests' do
    Rack::MockRequest.new(@app).post("", :input => SpecHelper::SampleInput).should be_ok
  end
  
  it 'should respond with error 404 to invalid requests' do
    Rack::MockRequest.new(@app).get("/foo", :input => 'foo=bar&moo=mar').should be_not_found
    Rack::MockRequest.new(@app).post("").should be_not_found
  end
  
  it 'should parse git diff stats to an Array of plugin names' do
    @app.parse_stats(SpecHelper::SampleDiffStats).should be_eql(%w{feather-one feather-two})
  end
  
  it 'should be able to build a package'

end