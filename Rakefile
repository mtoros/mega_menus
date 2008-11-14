require 'rubygems'
require 'rake'
 
begin
  require 'echoe'

  Echoe.new('mega_menus', '0.6.4') do |p|
    p.summary        = "Treeview menu Gem for Rails"
    p.description    = "Adds a model, controller to perform the tasks in order to have a treeview menu. To use this gem simply install it and write script/generate menu name_of_the_menu"
    p.author         = ['Marko Toros']
    p.email          = "mtoros@gmail.com"
    p.url            = ""
  end
rescue LoadError => boom
  puts "You are missing a dependency required for meta-operations on this gem."
  puts "#{boom.to_s.capitalize}."
end
