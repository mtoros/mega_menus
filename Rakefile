#require './lib/mega_menus.rb'
require 'rubygems'
require 'rake'
 
begin
  require 'echoe'

  Echoe.new('mega_menus', '0.1.3') do |p|
    p.summary        = "acts_as_menu Rails gem."
    p.description    = "acts_as_menu Rails gem."
    p.author         = ['Marko Toros', 'Rails Core']
    p.email          = "mtoros@gmail.com"
    p.url            = "http://www.krogla.si"
  end
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }
