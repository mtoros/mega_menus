module <%= "#{file_name.capitalize}Helper" %>
  def mega_menus(menu_model, menu_controller, admin_condition, admin_depth)
    #Checks
    if(!menu_checks(menu_model))
      return nil
    end
    #HTML generation
    html_generation(menu_model, menu_controller,admin_condition, admin_depth)
  end   

  def menu_checks(menu_model)
    if(!defined?(menu_model.check_menus))
      concat( "Are you sure you have called acts_as_menu")
      return FALSE
    end
    if(!menu_model.check_menus)
      concat( "You have not set correctly up the model.")
      return FALSE
    end
    return TRUE
  end

  def html_generation(menu_model, menu_controller,admin_condition, admin_depth)
    if(admin_condition)
      if(admin_depth.include?(1))
        concat link_to_remote(  "Add", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => 1,:menu_model=>menu_model, :menu_controller=>menu_controller } }, {:class => "menu_links_add", :id => "add_menu_link_1"})
        add_menu_form(menu_model, menu_controller,1)
      end
    end
    menu_list(menu_model, menu_controller,admin_condition, admin_depth)
  end

  def menu_list(menu_model, menu_controller,admin_condition,admin_depth)
    allmenus=menu_model.find(:all, :order => "absolute_position")
    #mdp...previous menu depth
    pmd=1
    
    if(!params[:menu_id].nil?)
        menu_id=params[:menu_id]
    elsif(!session[:menu_id].nil?)
        menu_id=session[:menu_id]
    end
    #concat "p= #{params[:menu_id]} ... s= #{session[:menu_id]} .... menu_id = #{menu_id} "
  
    firstm=TRUE
    allmenus.each do |m|
      if(m.id!=1)
        #check if your depth is correct
        if(admin_depth.include?(m.depth))
          if(firstm)
            concat( "<ul class=\"ul_menu_depth_#{m.depth}\">")
            firstm=FALSE
          elsif(m.depth > pmd)
            concat( "<ul class=\"ul_menu_depth_#{m.depth}\">")
          elsif(m.depth < pmd)
            pmd.downto(m.depth+1) {concat( "</ul>")}
          end
          pmd=m.depth
          #write the actual menu line for each record
          
          #make the selected view appear nicer
          if(m.id==menu_id.to_i)
            concat( "<li id=\"li_menu_#{m.id}\" class=\"li_menu_class_selected\">")
            concat( "<a  class=\"selected_menu\", id =\"menu_link_#{m.id}\" href=\"#{m.link}?menu_id=#{m.id}\"> #{m.title} #{m.id} </a>")
            session[:menu_id]=menu_id
          else
            concat( "<li id=\"li_menu_#{m.id}\" class=\"li_menu_class\">")
            concat( "<a  class=\"menu_link\", id =\"menu_link_#{m.id}\" href=\"#{m.link}?menu_id=#{m.id}\"> #{m.title} #{m.id} </a>")
          end
          if(admin_condition)
            concat( link_to_remote(  "Add", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :id => "add_menu_link_#{m.id}"}))
            concat( link_to_remote(  "Delete", {:url => {:controller => menu_controller, :action => 'delete_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_delete", :id => "delete_menu_link_#{m.id}"}))
            concat( link_to_remote(  "Edit", {:url => {:controller => menu_controller, :action => 'edit_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_edit", :id => "edit_menu_link_#{m.id}"}))
            concat( link_to_remote(  "Up", {:url => {:controller => menu_controller, :action => 'up_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_up",:id => "up_menu_link_#{m.id}"}))
            concat( link_to_remote(  "Down", {:url => {:controller => menu_controller, :action => 'down_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_down", :id => "down_menu_link_#{m.id}"}))
            add_menu_form(menu_model, menu_controller,m.id)
            edit_menu_form(menu_model, menu_controller,m)
          end
          concat( "</li>")
        end
      end
    end
    pmd.downto(1) {concat( "</ul>")}
    return nil
  end
  
  def add_menu_form(menu_model, menu_controller, menu_id)
      form_remote_tag(  :url => {:controller=>menu_controller, :action=> 'add_menu'}, :html => {:id => "add_menu_form_#{menu_id}", :class => "add_menu_form", :style=>"display: none"})  do
      concat( "Title:" )
      concat( text_field_tag( "title", "title"))
      concat( "Link:")
      concat( text_field_tag("link", "link"))
      concat( hidden_field_tag(:menu_id, menu_id))
      #content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat( submit_tag( "Add", :class => "add_button"))
      end
      return nil
  end


  def edit_menu_form(menu_model, menu_controller,m)
    form_remote_tag(  :url => {:controller=>menu_controller, :action=> 'edit_menu'}, :html => {:id => "edit_menu_form_#{m.id}",:class => "edit_menu_form", :style=>"display: none"})  do
      concat( "Title:")
      concat( text_field_tag( "title", m.title))
      concat( "Link:")
      concat( text_field_tag( "link", m.link))
      concat( "Parent:")
      concat( text_field_tag("parent_id", m.parent_id))
      concat( hidden_field_tag( :menu_id, m.id))
      #concat content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat( submit_tag( "Edit", :class => "edit__button"))
    end
    return nil
  end
end
