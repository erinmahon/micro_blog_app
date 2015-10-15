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
end
post '/signup' do
	@title = 'Signup'
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
	erb :logout
end



