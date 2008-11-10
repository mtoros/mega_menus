require 'test/unit'

require 'rubygems'
gem 'activerecord'
require 'active_record'

require "#{File.dirname(__FILE__)}/../lib/mega_menus"
require 'mega_menus'
MegaMenus.enable_activerecord

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :topics do |t|
      t.column :pos, :integer
      t.column :parent_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end
end
 
def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end
 
class Topic < ActiveRecord::Base
  acts_as_menu
end
 
class TestEditor < Test::Unit::TestCase
  def setup
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")
    setup_db
    (1..5).each { |counter| Topic.create! :pos => counter, :parent_id => counter }
  end
 
  def teardown
    teardown_db
  end
  
  def test_small
    assert_equal 5, Topic.count
  end

  def test_other
  end
  #add root, add menu, delete menu, ..., change position,...
end 