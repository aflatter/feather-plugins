require 'rubygems'
require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'
require 'spec/rake/spectask'
require 'fileutils'
require 'yaml'
require 'git'
require 'pp'
require 'erb'

namespace :feather do
  desc "Make plugin package"
  task :package do
    # Grab the path specified, or use all feather-* plugins found
    paths = ENV['path'].nil? ? Dir.glob("feather-*") : [ENV['path']]
    if paths.empty?
      # Show usage if no plugins are found and none is specified
      puts 'Usage: rake feather:package path=<plugin path> [target=<target path>]'
      return
    end
    # Setup default target if none specified, otherwise use that
    target = ENV['target'] ? ENV['target'] : File.join(File.dirname(__FILE__), 'pkg')
    # Loop through paths, packaging each one
    paths.each do |path|
      puts "Packaging... (#{path})"
      package(path, target)
    end
  end

  namespace :hook do
    desc "Install the PackageHookServer"
    task :install do

      file_path = ENV['path']
      
      unless file_path
        puts "Usage: rake feather:hook:install path=<target rackup file>"
        puts "  * target rackup file and it's parent directories will be created"
        return
      end

      dir_path  = File.dirname(file_path)

      erb = ERB.new(File.read(File.join(File.dirname(__FILE__), 'utils/templates/package_hook_server.ru.erb')))
      library_path = File.join(File.dirname(__FILE__), 'utils')
      repository_path = File.join(dir_path, 'repository')
      repository_url = Git.open(File.dirname(__FILE__)).remote('origin').url
      rackup = erb.result(binding)
      
      FileUtils.mkdir_p(dir_path)
      FileUtils.mkdir( %w{build repository}.map { |d| File.join(dir_path, d) }.select {|d| !File.exists?(d) } )
      File.open(file_path, 'w') {|f| f.write(rackup) }
      
    end
  end
end

##
# This packages the set path, with the specified target path
def package(path, target)
  # Load manifest
  puts "Load manifest..."
  manifest = YAML::load_file(File.join(path, 'manifest.yml'))
  
  # Target directory for package files
  puts "Target is: #{target}"
  Dir.mkdir(target) if not File.exists?(target)
    
  # Package name
  package = "#{manifest['name']}-#{manifest['version']}"
  puts "Package: #{package}"
    
  # Tgz
  manifest['package'] = "#{package}.tgz"
  command = "tar -czf #{package}.tgz --exclude pkg -C #{path} ."
  puts "Packing: #{command}"
  system command
  
  # Move
  puts "Finishing.."
  FileUtils.mv("#{package}.tgz", target)
  File.open(File.join(target, "#{package}.yml"), 'w') do |f|
    f.puts(manifest.to_yaml)
    f.close
  end
    
  puts "Done."
end