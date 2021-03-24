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
    @users = User.all
    @tweets = Tweet.all
    # binding.pry
    erb :index
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
       erb :login
     end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    # binding.pry
    if user.authenticate(params[:password])
      # binding.pry
      #log the user in
      session[:user_id] = user.id
      redirect "/tweets"
    else
      # binding.pry
      #send them to sign up!
      redirect "/signup"
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
    end
      redirect '/login'
  end

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    end
    @users = User.all
    erb :'/users/create_user'
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
      user = User.new(params)
      user.save
      session[:user_id]= user.id
      redirect '/tweets'
    end
    redirect '/signup'
  end

end
