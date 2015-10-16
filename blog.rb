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

	if @user.user_name == null
		#create account
		flash[:notice] = 'Congratulations!'
		session[:session_user_id] = 
		session[:session_user_name] = 
		redirect 'login_success'
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
	erb :logout, :layout => :home_layout
end



