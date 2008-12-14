module MegaMenus
  module Editor
    #here we want a class method!
    def self.included(base)
      base.extend ClassMethods
    end

    def isChildOf( parent_id)
      menu_id=self.id
      while(menu_id != 1)
        menu_id= self.class.parent_menu(menu_id).id
        if(menu_id===parent_id)
          return TRUE
        end
      end
      return FALSE
    end

    def isRootOf( child_id)
      menu_id=self.id

      while(child_id!=1)
        child_id= self.class.parent_menu(child_id).id
        if(menu_id===child_id)
          return TRUE
        end
      end
      return FALSE
    end

    def setPublished
      self.published=TRUE
      self.save!
      menu_id=self.id
      allmenus=self.class.all
      allmenus.each do |m|
        if(m.isChildOf(menu_id))
          m.published=TRUE
          m.save!
        end
        if(m.isRootOf(menu_id))
          m.published=TRUE
          m.save!
        end
      end
    end

    def setNotPublished
      self.published=FALSE
      self.save!
      parent_id=self.id
      allmenus=self.class.all
      allmenus.each do |m|
        if(m.isChildOf(parent_id))
          m.published=FALSE
          m.save!
        end
      end
    end

    def children
      self.class.children(self.id)
    end


    module ClassMethods
      def acts_as_menu
        self.send :extend, MenuClassMethods
      end  
    end
  end
  module MenuClassMethods
    def check_menus
      #title, id, parent_id, link
      cn=self.column_names
      if(!cn.include?("id"))
        return FALSE
      end
      if(!cn.include?("title"))
        return FALSE
      end
      if(!cn.include?("parent_id"))
        return FALSE
      end
      if(!cn.include?("link"))
        return FALSE
      end
      if(!cn.include?("position"))
        return FALSE
      end
      if(!cn.include?("absolute_position"))
        return FALSE
      end
      if(!cn.include?("depth"))
        return FALSE
      end
      #model correct
      return TRUE
    end
    
    def add_child(menu_id, title, link)
      position=assign_position(menu_id)
      child = self.new( "title" => title,
                        "link" => link,
                        "parent_id" => menu_id,
                        "position" => position,
                        "published" => FALSE)
      child.save!
      return child
    end

    def assign_position(parent_id)
      c=children(parent_id)
      if(!c.empty?)
        position= (c.max {|c1,c2| c1.position <=> c2.position}).position + 1  
      else
        position=1
      end
      return position
    end

    def children(menu_id)
      self.find(:all, :order=> "position" ,:conditions => { :parent_id=>menu_id})
    end

    def parent_menu(menu_id)
      m=self.find(menu_id)
      self.find(:first,:conditions => { :id=>m.parent_id})
    end

    def siblings(menu_id)
      p=parent_menu(menu_id)
      ac=children(p.id)
      i=0
      ac.each do |c|
        if(c.id==menu_id)
          ac.delete_at(i) 
          break         
        end
        i=i+1
      end
      return ac
    end

    #sorry..for the spin word...:)
    def get_menu(parent_id, position)  
      self.find(:first,:conditions => { :parent_id=>parent_id, :position => position})
    end

    def switch_menu_positions(parent_id, position1, position2)
      menu1=get_menu(parent_id,position1)
      menu2=get_menu(parent_id,position2)
      menu1.position,menu2.position =menu2.position,menu1.position
      menu1.save!
      menu2.save!
    end

    def position_up(id)
      menu=self.find(id)
      if(menu.position>1)
        switch_menu_positions(menu.parent_id, menu.position, menu.position-1)
      end
    end
    
    def position_down(id)
      menu=self.find(id)
      if(!siblings(id).empty?)
        if(menu.position< (siblings(id).max {|c1,c2| c1.position <=> c2.position}).position)
          switch_menu_positions(menu.parent_id, menu.position, menu.position+1)
        end
      end
    end

    def edit(menu_id, new_parent_id, title, link)
      menu=self.find(menu_id)
      menu.update_attributes!(:title=> title,:link=> link)
      if(menu.parent_id != new_parent_id)
        position=assign_position(new_parent_id)
        newmenu=self.new(:title=>title, :link=>link, :parent_id=>new_parent_id, :position=>position)
        newmenu.save!
        children(menu.id).each do |c|
          c.parent_id=newmenu.id
          c.save!
        end
        siblings(menu).each do |s|
          if(s.position>menu.position)
            s.decrement(:position)
            s.save!
          end
        end
        self.delete(menu_id)
        end
    end

    def delete_item(menu_id)
      menu=self.find(menu_id)
      if(children(menu_id).empty?)
        siblings(menu_id).each do |s|
          if(s.position>menu.position)
            s.decrement(:position)
            s.save! 
          end
        end
      else
        siblings(menu.id).each do |s|
          if(s.position>menu.position)
            s.position+=children(menu.id).count - 1
            s.save! 
          end
        end
      end
      #actual move
      children(menu.id).each do |c|
        c.position+=menu.position-1
        c.parent_id=menu.parent_id
        c.save!
      end
      self.delete(menu_id)
    end
    
    def determine_abs_position_and_depth
      roots=self.find(:all,:order=>"position",:conditions => {:parent_id=>1} )
      ap=0
      depth=1
      roots.each do |r|
        ap+=1
        r.absolute_position=ap
        r.depth=depth
        r.save!
        ap,depth=recursive_dapad(r,ap,depth)
      end
    end
    
    def recursive_dapad(rp,ap,depth)
      depth+=1
      children(rp.id).each do |m|
        ap+=1
        m.absolute_position=ap
        m.depth=depth
        m.save!
        ap,depth=recursive_dapad(m,ap,depth)
      end
      depth-=1
      return ap,depth
    end

    def delete_children(menu_id)
      #need to implement all_children first
      #self.find(menu_id).all_children.each do |c|
      #  self.delete(c.id)
      #end        
    end
   end
end