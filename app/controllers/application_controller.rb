require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  helpers do
    def logged_in?
      session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/' do
    erb :'/static/index'
  end

  get '/signup' do
    erb :'static/login'
  end

  post '/signup' do
    user = User.create(params)
    session[:user_id] = user.id
    redirect '/tweets'
  end

  get '/login' do
    erb :'static/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.password == params[:password]
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.destroy
    redirect '/'
  end
end
