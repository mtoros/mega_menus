class <%= "#{file_name.capitalize+ "editor" + "Controller"}" %> < ApplicationController

  def add_menu_form
    @menu_id=params[:menu_id]
  end  

  def add_menu
    <%= file_name.capitalize %>.add_child(params[:menu_id].to_i, params[:title], params[:link])
    <%= file_name.capitalize %>.determine_abs_position_and_depth
    
  end

  def delete_menu
    temp=<%= file_name.capitalize %>.find(params[:menu_id]).parent_id

    <%= file_name.capitalize %>.delete_item(params[:menu_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
    session[:menu_id]=temp
    params[:menu_id]=temp
  end

  def edit_menu_form
    @menu_id=params[:menu_id]
  end
  
  def edit_menu
    <%= file_name.capitalize %>.edit(params[:menu_id].to_i, params[:parent_id].to_i, params[:title], params[:link])
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end

  def up_menu
    <%= file_name.capitalize %>.position_up(params[:menu_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end

  def down_menu
    <%= file_name.capitalize %>.position_down(params[:menu_id].to_i)
    <%= file_name.capitalize %>.determine_abs_position_and_depth
  end
end
