class <%= "#{file_name.capitalize+ "editor" + "Controller"}" %> < ApplicationController

  def add_menu_form
    @menu_id=params[:<%="#{file_name}"%>_id]
  end  

  def add_menu
    <%= file_name.capitalize %>.add_child(params[:<%="#{file_name}"%>_id].to_i, params[:title], params[:link])
    <%= file_name.capitalize %>.determine_abs_position_and_depth
    
  end

  def publish_menu
    m=<%= file_name.capitalize %>.find(params[:<%="#{file_name}"%>_id].to_i)
    if(m.published)
      m.setNotPublished
    else
      m.setPublished
    end
  end

  def delete_menu
    temp=<%= file_name.capitalize %>.find(params[:<%="#{file_name}"%>_id]).parent_id

    <%= file_name.capitalize %>.delete_item(params[:<%="#{file_name}"%>_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
    session[:<%="#{file_name}"%>_id]=temp
    params[:<%="#{file_name}"%>_id]=temp
  end

  def edit_menu_form
    @menu_id=params[:<%="#{file_name}"%>_id]
  end
  
  def edit_menu
    <%= file_name.capitalize %>.edit(params[:<%="#{file_name}"%>_id].to_i, params[:parent_id].to_i, params[:title], params[:link])
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end

  def up_menu
    <%= file_name.capitalize %>.position_up(params[:<%="#{file_name}"%>_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end

  def down_menu
    <%= file_name.capitalize %>.position_down(params[:<%="#{file_name}"%>_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end
end
