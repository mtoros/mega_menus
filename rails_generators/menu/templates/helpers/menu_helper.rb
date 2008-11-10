module <%= "#{file_name.capitalize}Helper" %>
  def mega_menus(menu_model, menu_controller, admin_condition)
    #Checks
    if(!menu_checks(menu_model))
      return nil
    end

    #HTML generation
    html_generation(menu_model, menu_controller,admin_condition)
  end   

  def menu_checks(menu_model)
    if(!defined?(menu_model.check_menus))
      concat "Are you sure you have called acts_as_menu"
      return FALSE
    end
    if(!menu_model.check_menus)
      concat "You have not set correctly up the model."
      return FALSE
    end
    return TRUE
  end

  def html_generation(menu_model, menu_controller,admin_condition)
    concat "<div id=\"mega_menus\">"
    if(admin_condition)
      concat "Add Root:"
      concat link_to_remote  "Add", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => 1,:menu_model=>menu_model, :menu_controller=>menu_controller } }, {:class => "menu_links", :id => "add_child_link_#{1}"}
      add_menu_form(menu_model, menu_controller,1)
    end
    menu_list(menu_model, menu_controller,admin_condition)
    concat "</div>"
  end

  def menu_list(menu_model, menu_controller,admin_condition)
    allmenus=menu_model.find(:all, :order => "absolute_position")
    concat "<ul>"
    #mdp...previous menu depth
    pmd=1
    allmenus.each do |m|
      if(m.id!=1)
        if(m.depth > pmd)
          pmd.upto(m.depth-1) {concat "<ul>"}
        end
        if(m.depth < pmd)
          pmd.downto(m.depth+1) {concat "</ul>"}
        end
        pmd=m.depth
        #write the actual menu line for each record
        concat "<li>"
        #make the selected view appear nicer
        if(m.id==params[:menu_id].to_i or m.link==request.request_uri)
          concat "<div id=\"selected_mega_menu\">"
        end
        concat link_to  "#{m.title} #{m.id} ",  m.link
        if(m.id==params[:menu_id].to_i or m.link==request.request_uri)
          concat "</div>"
        end
        if(admin_condition)
          concat link_to_remote  "Add", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links", :id => "add_menu_link_#{m.id}"}
          concat link_to_remote  "Delete", {:url => {:controller => menu_controller, :action => 'delete_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links", :id => "delete_menu_link_#{m.id}"}
          concat link_to_remote  "Edit", {:url => {:controller => menu_controller, :action => 'edit_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links", :id => "edit_menu_link_#{m.id}"}
          concat link_to_remote  "Up", {:url => {:controller => menu_controller, :action => 'up_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links",:id => "up_menu_link_#{m.id}"}
          concat link_to_remote  "Down", {:url => {:controller => menu_controller, :action => 'down_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links", :id => "down_menu_link_#{m.id}"}
          add_menu_form(menu_model, menu_controller,m.id)
          edit_menu_form(menu_model, menu_controller,m)
        end
        concat "</li>"
      end
    end
    concat "<\ul>"

    return nil
  end
  
  def add_menu_form(menu_model, menu_controller, menu_id)
      form_remote_tag  :url => {:controller=>menu_controller, :action=> 'add_menu'}, :html => {:id => "add_menu_form_#{menu_id}", :style=>"display: none"}  do
      concat "<div>" 
      concat "Title:" 
      concat text_field_tag "title", "title"
      concat "Link:"
      concat text_field_tag "link", "link"
      concat hidden_field_tag :menu_id, menu_id
      #content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat submit_tag "Add"
      concat "</div>"
      end
      return nil
  end


  def edit_menu_form(menu_model, menu_controller,m)
    form_remote_tag  :url => {:controller=>menu_controller, :action=> 'edit_menu'}, :html => {:id => "edit_menu_form_#{m.id}", :style=>"display: none"}  do
      concat "<div>"  
      concat "Title:" 
      concat text_field_tag "title", m.title
      concat "Link:"
      concat text_field_tag "link", m.link
      concat "Parent:"
      concat text_field_tag "parent_id", m.parent_id
      concat hidden_field_tag :menu_id, m.id
      #concat content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat submit_tag "Edit"
      concat "</div>"
    end
    return nil
  end   
end
