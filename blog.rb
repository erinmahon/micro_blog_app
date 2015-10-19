require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
enable :sessions

set :database, 'sqlite3:blogdb.sqlite3'

#references models.rb page
require './models'

get '/' do
	@title = 'Home'
	erb :home, :layout => :home_layout
end
post '/login' do
	@title = 'Login'
	@user = User.where(user_name: params[:user_name]).first

	if @user.nil?
		flash[:alert] = 'Bad News!'
		redirect '/failed'
	else
		if @user.user_password == params[:password]
			flash[:notice] = 'Congratulations!'
			session[:session_user_id] = @user.id
			session[:session_user_name] = @user.user_name
			redirect '/login_success'
		else
			redirect '/failed'
		end
	end
end
post '/signup' do
	@title = 'Signup'
	@user = User.where(user_name: params[:user_name]).first

	if @user.nil?
		if params[:email_1] != params[:email_2] || params[:email_1] == ""
			flash[:alert] = 'The emails do not match or blank'
			redirect '/failed'
		elsif params[:password_1] != params[:password_2] || params[:password_1].length < 6
			flash[:alert] = 'The passwords do not match or at least 6 characters long'
			redirect '/failed'
		else
			@user = User.create(user_name: params[:user_name], user_password: params[:password_1])
			@profile = Profile.create(email: params[:email_1], user_id: @user.id)
			flash[:notice] = 'Congratulations!'
			session[:session_user_id] = @user.id
			session[:session_user_name] = @user.user_name
			redirect 'login_success'
		end
	else
		flash[:alert] = 'The username: #{params[:user_name] has been taken'
		redirect '/failed'
	end
end
get '/login_success' do
	@title = 'You are signed in!'
	@followees = Follow.where(follower_id: session[:session_user_id])
	erb :success
end
get '/failed' do
	@title = 'Login / Signup Failed'
	flash[:alert] = 'Bad News!'
	erb :home, :layout => :home_layout
end
get '/profile' do
	@title = 'Your Profile'
	@user = User.find(session[:session_user_id])
	@my_profile = Profile.find_by(user_id: session[:session_user_id])
	@posts = Post.where(user_id: session[:session_user_id])
	erb :profile
end
get '/edit' do
	@title = 'Edit Your Profile'
	@my_profile = Profile.find_by(user_id: session[:session_user_id])
	erb :edit_profile
end
post '/edit_submit' do
	@title = 'Your Profile'
	@my_profile = Profile.find_by(user_id: session[:session_user_id])
	@my_profile.update(first_name: params[:first_name], last_name: params[:last_name], birthday: params[:birthday], email: params[:email], work: params[:work])
	redirect 'profile'
end
get '/logout' do
	session.clear
	erb :logout, :layout => :home_layout
end
get '/users' do
	@title = 'Users'
	@users = User.all
	erb :users
end
get '/:user_name' do
	@title = params[:user_name]
	@user = User.find_by(user_name: params[:user_name])
	@followers = Follow.where(user_id: @user.id)
	@profile = Profile.find_by(user_id: @user.id)
	@posts = Post.where(user_id: @user.id)
	@follow = false
	@followers.each do |follower|
		if follower.follower_id == session[:session_user_id]
			@follow = true
		end 
	end
	erb :user
end
post '/follow' do
	if params[:follow] == 'true'
		Follow.create(user_id: params[:followee], follower_id: session[:session_user_id])
	else
		Follow.where(user_id: params[:followee], follower_id: session[:session_user_id]).destroy_all
	end
	redirect back
end
post '/post' do
	@title = 'Your Profile'
	if params[:post] != ""
		Post.create(user_id: session[:session_user_id], date: Date.today, time: Time.now, message: params[:post])
	end
	redirect back
end