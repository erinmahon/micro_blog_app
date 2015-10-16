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

	if @user.user_password == params[:password]
		flash[:notice] = 'Congratulations!'
		session[:session_user_id] = @user.id
		session[:session_user_name] = @user.user_name
		redirect '/login_success'
	else
		flash[:alert] = 'Bad News!'
		redirect '/failed'
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
	erb :success
end
get '/failed' do
	@title = 'Login / Signup Failed'
	erb :fail, :layout => :home_layout
end
get '/profile' do
	@title = 'Your Profile'
	erb :profile
end
get '/logout' do
	session.clear
	erb :logout, :layout => :home_layout
end