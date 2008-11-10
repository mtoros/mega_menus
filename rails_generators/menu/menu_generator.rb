class MenuGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      #create the menu controller
      m.template "controllers/menu_controller.rb", "app/controllers/#{file_name}editor_controller.rb"
      #create the views
      m.directory File.join('app/views/', "#{file_name}editor")
      m.template "views/add_menu_form.rjs", "app/views/#{file_name}editor/add_menu_form.rjs"
      m.template "views/add_menu.rjs", "app/views/#{file_name}editor/add_menu.rjs"
      m.template "views/delete_menu.rjs", "app/views/#{file_name}editor/delete_menu.rjs"
      m.template "views/edit_menu_form.rjs", "app/views/#{file_name}editor/edit_menu_form.rjs"
      m.template "views/edit_menu.rjs", "app/views/#{file_name}editor/edit_menu.rjs"
      m.template "views/up_menu.rjs", "app/views/#{file_name}editor/up_menu.rjs"
      m.template "views/down_menu.rjs", "app/views/#{file_name}editor/down_menu.rjs"
      m.template "views/_menu.html.erb", "app/views/#{file_name}editor/_#{file_name}.html.erb"
      #create the helper
      m.template "helpers/menu_helper.rb", "app/helpers/#{file_name}_helper.rb"
      #create the models
      m.directory 'db/migrate/'
      m.template "models/create_menus.rb", "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{file_name}s.rb"
      m.template "models/menu.rb", "app/models/#{file_name}.rb"
    end
  end
end

