class CreatePostsTable < ActiveRecord::Migration
  def change
  	create_table :posts do |t|
  		t.integer :user_id
  		t.date :date
  		t.time :time
  		t.string :message, limit: 150
  	end
  end
end
