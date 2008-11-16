class <%= "#{'Create' + file_name.capitalize + 's'}" %> < ActiveRecord::Migration
  def self.up
    create_table <%= ":#{file_name + 's'}" %>,:force => true do |t|
      t.string     :title
      t.string     :link
      t.integer    :parent_id
      t.integer    :position
      t.integer    :absolute_position
      t.integer    :depth
      t.boolean    :published
      t.timestamps
    end
    
    <%= file_name.capitalize %>.create :id => 1, :position=>0, :absolute_position=>0, :depth=>1, :parent_id=>0,:published=>FALSE
  end


  def self.down
    drop_table <%= ":#{file_name + 's'}" %>
  end
end
