module MegaMenus
  class << self
    def enable
      enable_actionpack
      enable_activerecord
    end
    
    def enable_actionpack
    #  require 'mega_menus/view_helpers'
    #  ActionView::Base.send :include, ViewHelpers
    end
    
    def enable_activerecord
      require 'mega_menus/editor'
      ActiveRecord::Base.send :include, Editor
    end
  end
end

if defined?(Rails) and defined?(ActiveRecord) and defined?(ActionController)
  MegaMenus.enable
end
