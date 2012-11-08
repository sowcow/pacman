require 'rspec_explain'
require_here 'spec/support'
require_here 'lib'


BEGIN{
  # TODO find or create gem
  def require_here dir
    dir = dir
    raise "Dir not found: '#{dir}'=='#{File.expand_path dir }'" unless Dir.exist? dir
    Dir["#{dir}/*.rb"].each {|file| require File.expand_path file }
  end
}