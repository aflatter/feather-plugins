
require File.join(File.dirname(__FILE__), '..', 'package_hook_server')
require 'rubygems'
require 'cgi'

module SpecHelper

  SampleJson = <<-EOD
  { 
    "before": "019c87d0e432fa923e793b9a6e7faab7f338d6de",
    "repository": {
      "url": "http://some.url.com/repo",
      "name": "repo",
      "author": {
        "email": "some@user.com",
        "name": "Some User" 
      }
    },
    "commits": {
      "019c87d0e432fa923e793b9a6e7faab7f338d6de": {
        "url": "http://some.url.com/commit/019c87d0e432fa923e793b9a6e7faab7f338d6de",
        "author": {
          "email": "el@eldiablo.co.uk",
          "name": "El Draper" 
        },
        "message": "fix some of these install files to simplify plugin installation",
        "timestamp": "2008-02-15T14:36:34-08:00" 
      }
    },
    "after": "4299ce8fa5f35a0c8c921bcac9bebd663e123406",
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

    def generate_temp_path(string)
      temp_path = "/tmp/spec-#{Time.now.to_i}-#{string || $$}-#{rand(1000)}"
      File.exists?(temp_path) ? generate_temp_path(string) : temp_path
    end
    
  end

end