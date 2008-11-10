Gem::Specification.new do |s|
  s.name    = 'mega_menus'
  s.version = '0.4.1'
  s.date    = '2008-11-10'
  
  s.summary = "Treeview Menus Gem for Rails"
  s.description = "A Rails Gem for editing a treeview menu structure."
  
  s.authors  = ['Marko Toros']
  s.email    = 'mtoros@gmail.com'
  s.homepage = '#'
  
  
  s.files = %w(Manifest README Rakefile lib/mega_menus.rb lib/mega_menus/editor.rb lib/mega_menus/view_helpers.rb test/test_editor.rb
rails_generators/menu/USAGE rails_generators/menu/menu_generator.rb rails_generators/menu/templates/controllers/menu_controller.rb  rails_generators/menu/templates/views/add_menu_form.rjs rails_generators/menu/templates/views/add_menu.rjs rails_generators/menu/templates/views/delete_menu.rjs rails_generators/menu/templates/views/edit_menu_form.rjs rails_generators/menu/templates/views/edit_menu.rjs
rails_generators/menu/templates/views/up_menu.rjs rails_generators/menu/templates/views/down_menu.rjs rails_generators/menu/templates/views/_menu.html.erb
rails_generators/menu/templates/helpers/menu_helper.rb rails_generators/menu/templates/models/create_menus.rb rails_generators/menu/templates/models/menu.rb)

  s.test_files = %w(test/test_editor.rb)
end
