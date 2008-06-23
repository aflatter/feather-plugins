
require File.join(File.dirname(__FILE__), '..', 'package_hook_server')
require 'rubygems'
require 'cgi'

module SpecHelper

  SampleJson = <<-EOD
  { 
    "before": "2a03908c7167daab58459a362789f3b809e29f72",
    "repository": {
      "url": "http://some.url.com/repo",
      "name": "repo",
      "author": {
        "email": "some@user.com",
        "name": "Some User" 
      }
    },
    "commits": {
      "4901775b4c9efd217e5f6bda2522177ee8218238": {
        "url": "http://some.url.com/commit/4901775b4c9efd217e5f6bda2522177ee8218238",
        "author": {
          "email": "some@user.com",
          "name": "Some User" 
        },
        "message": "Deleted A",
        "timestamp": "2008-02-15T14:57:17-08:00" 
      },
      "3b7613dca210dbcf69942aaf01048b65bfc84176": {
        "url": "http://some.url.com/commit/3b7613dca210dbcf69942aaf01048b65bfc84176",
        "author": {
          "email": "some@user.com",
          "name": "Some User" 
        },
        "message": "Modified A; Added C",
        "timestamp": "2008-02-15T14:57:17-08:00" 
      },
      "2ae9f3b315cab68e06aa71a69a2524be868b600f": {
        "url": "http://some.url.com/commit/2ae9f3b315cab68e06aa71a69a2524be868b600f",
        "author": {
          "email": "some@user.com",
          "name": "Some User" 
        },
        "message": "Modified B",
        "timestamp": "2008-02-15T14:57:17-08:00" 
      },
      "3a99e9c0fc0aaa00f959344778b6ada155444c7e": {
        "url": "http://some.url.com/commit/3a99e9c0fc0aaa00f959344778b6ada155444c7e",
        "author": {
          "email": "some@user.com",
          "name": "Some User" 
        },
        "message": "Added B",
        "timestamp": "2008-02-15T14:36:34-08:00" 
      }
    },
    "after": "4901775b4c9efd217e5f6bda2522177ee8218238",
    "ref": "refs/heads/master" 
  }
  EOD

  SampleInput = "payload=#{CGI.escape(SampleJson)}"
  
  SampleRepositoryPath = File.join(File.dirname(__FILE__), 'sample_repository')
  
  SampleDiffStats = {
    :total => {
      :insertions => 2,
      :deletions => 1,
      :lines=>3,
      :files=>3
    },
   :files => {
     "feather-one/blah"     => {:insertions=>0, :deletions=>1},
     "feather-two/foo"      => {:insertions=>1, :deletions=>0},
     "feather-one/bar/baz"  => {:insertions=>1, :deletions=>0},
     "foobar/feather"       => {:whatever=>0}
    }
  }
  
  class << self

    def generate_temp_path
      temp_path = "/tmp/spec-#{$$}-#{Time.now.to_i}-#{rand(1000)}"
      File.exists?(temp_path) ? generate_temp_path : temp_path
    end
    
  end

end