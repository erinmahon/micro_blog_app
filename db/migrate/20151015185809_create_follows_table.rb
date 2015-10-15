class CreateFollowsTable < ActiveRecord::Migration
  def change
  	create_table :follows do |t|
  		t.integer :user_id
  		t.integer :follower_id
  	end
  end
end
