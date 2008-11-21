module <%= "#{file_name.capitalize}Helper" %>
  def mega_menus(menu_model, menu_controller, admin_condition, admin_depth, admin_parent)
    #Checks
    if(!menu_checks(menu_model))
      return nil
    end
    #HTML generation
    html_generation(menu_model, menu_controller,admin_condition, admin_depth, admin_parent)
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

  def html_generation(menu_model, menu_controller,admin_condition, admin_depth, admin_parent)
    allmenus=menu_model.find(:all, :order => "absolute_position")
    #mdp...previous menu depth
    pmd=1

    if(!params[:menu_id].nil?)
        menu_id=params[:menu_id]
    elsif(!session[:menu_id].nil?)
        menu_id=session[:menu_id]
    end

    firstm=TRUE
    allmenus.each do |m|
      #write the actual menu line for each record
      if(m.published==TRUE or admin_condition==TRUE)
        if(m.id==1 and m.children.empty? and admin_depth.include?(m.depth))
          concat( "<ul id=\"ul_menu_#{m.depth}\" class=\"ul_menu_depth_#{m.depth} ul_menu\">")
            if(admin_condition)
              concat( "<li id=\"root_add_#{m.id}\" class=\"root_add\">")
              concat( link_to_remote(  "<span>Add</span>", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :title=> "Add",:id => "add_menu_link_#{m.id}"}))
              add_menu_form(menu_model, menu_controller, m.id)
              concat( "</li>")
            end
            firstm=FALSE
        end
        if(m.id!=1 and m.isChildOf(admin_parent))
          #check if your depth is correct
          if(admin_depth.include?(m.depth))
            if(m.depth > pmd or firstm)
              concat( "<ul id=\"ul_menu_#{m.depth}\" class=\"ul_menu_depth_#{m.depth} ul_menu\">")
              if(admin_condition)
                concat( "<li id=\"root_add_#{m.parent_id}\" class=\"root_add\">")
                concat( link_to_remote(  "<span>Add</span>", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.parent_id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :title=> "Add",:id => "add_menu_link_#{m.id}"}))
                add_menu_form(menu_model, menu_controller, m.parent_id)
                concat( "</li>")
              end
              firstm=FALSE
            elsif(m.depth < pmd)
              pmd.downto(m.depth+1) {concat( "</ul>")}
            end
            pmd=m.depth

            #make the selected view appear nicer
            if(m.id==menu_id.to_i)
              concat( "<li id=\"li_menu_#{m.id}\" class=\"li_menu_class_selected\">")
              concat( "<a  class=\"selected_menu\" id =\"menu_link_#{m.id}\" href=\"#{m.link}?menu_id=#{m.id}\"> #{m.title} </a>")
              session[:menu_id]=menu_id
            else
              concat( "<li id=\"li_menu_#{m.id}\" class=\"li_menu_class\">")
              concat( "<a  class=\"menu_link\" id =\"menu_link_#{m.id}\" href=\"#{m.link}?menu_id=#{m.id}\"> #{m.title} </a>")
            end
            if(admin_condition)
              #remove the comment on the following line depending on the view you want to have
              #concat( link_to_remote(  "<span>Add</span>", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :title=> "Add",:id => "add_menu_link_#{m.id}"}))
              # DELETE
              concat( link_to_remote(  "<span>Delete</span>", {:url => {:controller => menu_controller, :action => 'delete_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}, :confirm => "Are you sure?"}, {:class => "menu_links_delete", :title=> "Delete",:id => "delete_menu_link_#{m.id}"}))
              # EDIT
              concat( link_to_remote(  "<span>Edit</span>", {:url => {:controller => menu_controller, :action => 'edit_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_edit",:title=> "Edit", :id => "edit_menu_link_#{m.id}"}))
              # UP
              concat( link_to_remote(  "<span>Up</span>", {:url => {:controller => menu_controller, :action => 'up_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_up", :title=> "Up",:id => "up_menu_link_#{m.id}"}))
              # DOWN
              concat( link_to_remote(  "<span>Down</span>", {:url => {:controller => menu_controller, :action => 'down_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_down", :title=> "Down", :id => "down_menu_link_#{m.id}"}))
              # PUBLISH
              if(m.published==TRUE)
                mp="menu_links_published"
                mpt="published"
              else
                mp="menu_links_not_published"
                mpt="not published"
              end
              concat( link_to_remote(  "<span>Publish</span>", {:url => {:controller => menu_controller, :action => 'publish_menu', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => mp, :title=> mpt, :id => "publish_menu_link_#{m.id}"}))
              # EDIT FORM
              edit_menu_form(menu_model, menu_controller,m)
            end
            concat( "</li>")
            if(admin_condition and m.children.empty? and admin_depth.include?(m.depth+1))
              concat( "<ul id=\"ul_menu_#{m.depth+1}\" class=\"ul_menu_depth_#{m.depth+1} ul_menu\">")
                concat( "<li id=\"root_add_#{m.id}\" class=\"root_add\">")
                concat( link_to_remote(  "<span>Add</span>", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id => m.id,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :title=> "Add",:id => "add_menu_link_#{m.id}"}))
                add_menu_form(menu_model, menu_controller, m.id)
                concat( "</li>")
              concat( "</ul>")
            end
          end
        end
      end
    end
    if(firstm==TRUE and <%= "#{file_name.capitalize}" %>.exists?(admin_parent) and admin_parent!=1)
      concat( "<ul id=\"ul_menu_#{admin_depth.first}\" class=\"ul_menu_depth_#{admin_depth.first} ul_menu\">")
      if(admin_condition)
        concat( "<li id=\"root_add_#{admin_parent}\" class=\"root_add\">")
        concat( link_to_remote(  "<span>Add</span>", {:url => {:controller => menu_controller, :action => 'add_menu_form', :menu_id =>  admin_parent,:menu_model=>menu_model, :menu_controller=>menu_controller}}, {:class => "menu_links_add", :title=> "Add",:id => "add_menu_link_#{admin_parent}"}))
        add_menu_form(menu_model, menu_controller, admin_parent)
        concat( "</li>")
      end
      pmd=admin_depth.first
    elsif(firstm==TRUE)
      concat( "<ul id=\"ul_menu_#{admin_depth.first}\" class=\"ul_menu_depth_#{admin_depth.first} ul_menu\">")
      pmd=admin_depth.first
    end
    pmd.downto(admin_depth.first) {concat( "</ul>")}

    return nil
  end
  
  def add_menu_form(menu_model, menu_controller, menu_id)
      form_remote_tag(  :url => {:controller=>menu_controller, :action=> 'add_menu'}, :html => {:id => "add_menu_form_#{menu_id}", :class => "add_menu_form", :style=>"display: none"})  do
      concat( "Title:" )
      concat( text_field_tag( "title", "", :id=>"a_tft_title_#{menu_id}"))
      concat( "Link:")
      concat( text_field_tag("link", "",:id=>"a_tft_link_#{menu_id}"))
      concat( hidden_field_tag(:menu_id, menu_id, :id=>"a_tft_menu_id_#{menu_id}"))
      #content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat( submit_tag( "Add", :class => "add_button"))
      end
      return nil
  end


  def edit_menu_form(menu_model, menu_controller,m)
    form_remote_tag(  :url => {:controller=>menu_controller, :action=> 'edit_menu'}, :html => {:id => "edit_menu_form_#{m.id}",:class => "edit_menu_form", :style=>"display: none"})  do
      concat( "Title:")
      concat( text_field_tag( "title", m.title, :id=>"e_tft_title_#{m.id}" ))
      concat( "Link:")
      concat( text_field_tag( "link", m.link,:id=>"e_tft_link_#{m.id}"))
      concat( "Parent:")
      concat( text_field_tag("parent_id", m.parent_id, :id=>"e_tft_parent_id_#{m.id}"))
      concat( hidden_field_tag( :menu_id, m.id,:id=>"e_tft_menud_id_#{m.id}"))
      #concat content_tag :button, "Submit", {:type=>"submit", :class=>"button-submit"}
      concat( submit_tag( "Edit", :class => "edit__button"))
    end
    return nil
  end
end
