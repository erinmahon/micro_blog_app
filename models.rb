class User < ActiveRecord::Base
	has_one :profile
	has_many :posts
	has_many :comments
	has_many :followers, through: :users_followers
end
class Profile < ActiveRecord::Base
	belongs_to :user
end
class Post < ActiveRecord::Base
	belongs_to :user
	has_many :comments
end
class Comment < ActiveRecord::Base
	belongs_to :user
	belongs_to :post
	belongs_to :comment
	has_many :comments
end
class Follower < User
	has_many :users, through: :users_followers
end
class User_Follower < ActiveRecord::Base
	belongs_to :user
	belongs_to :follower
end