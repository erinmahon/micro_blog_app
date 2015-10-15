class CreateCommentsTable < ActiveRecord::Migration
  def change
  	create_table :comments do |t|
  		t.integer :user_id
  		t.integer :post_id
  		t.integer :parent_id
  		t.date :date
  		t.time :time
  		t.string :comment, limit: 150
  	end
  end
end
