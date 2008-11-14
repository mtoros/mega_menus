Gem::Specification.new do |s|
  s.name = %q{mega_menus}
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marko Toros"]
  s.date = %q{2008-11-14}
  s.description = %q{Adds a model, controller to perform the tasks in order to have a treeview menu. To use this gem simply install it and write script/generate menu name_of_the_menu}
  s.email = %q{mtoros@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/mega_menus.rb", "lib/mega_menus/editor.rb", "lib/mega_menus/view_helpers.rb"]
  s.files = ["Manifest", "README.rdoc", "init.rb", "Rakefile", "lib/mega_menus.rb", "lib/mega_menus/editor.rb", "lib/mega_menus/view_helpers.rb", "test/test_editor.rb", "rails_generators/menu/USAGE", "rails_generators/menu/menu_generator.rb", "rails_generators/menu/templates/controllers/menu_controller.rb", "rails_generators/menu/templates/views/add_menu_form.rjs", "rails_generators/menu/templates/views/add_menu.rjs", "rails_generators/menu/templates/views/delete_menu.rjs", "rails_generators/menu/templates/views/edit_menu_form.rjs", "rails_generators/menu/templates/views/edit_menu.rjs", "rails_generators/menu/templates/views/up_menu.rjs", "rails_generators/menu/templates/views/down_menu.rjs", "rails_generators/menu/templates/views/_menu.html.erb", "rails_generators/menu/templates/helpers/menu_helper.rb", "rails_generators/menu/templates/models/create_menus.rb", "rails_generators/menu/templates/models/menu.rb", "mega_menus.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Mega_menus", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{mega_menus}
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{Treeview menu Gem for Rails}
  s.test_files = ["test/test_editor.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
