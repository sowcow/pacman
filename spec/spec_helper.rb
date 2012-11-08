require 'rspec_explain'
require_here 'lib'
require_here 'spec/support'


BEGIN{
  def require_here dir # TODO find or create gem
    dir = dir
    raise "Dir not found: '#{dir}'=='#{File.expand_path dir }'" unless Dir.exist? dir
    Dir["#{dir}/*.rb"].each {|file| require File.expand_path file }
  end
}