require './config/environment'


class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "string"
  end

  helpers do
    def logged_in?
      session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  #read
  get '/' do
    erb :index
  end

  get '/tweets' do
    @tweets = Tweet.all
    erb :all
  end

  #read
  get '/signup' do
    erb :signup
  end

  #create
  post '/signup' do
    user = User.create(username: params[:username], email: params[:email], password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  #read
  get '/login' do
    erb :login
  end

  post '/login' do
    user = User.find_by(username: params[:username], password: params[:password])
    if user
      session[:user_id] = user.id
      redirect '/'
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    session.destroy
    redirect '/login'
  end

  #read
  get '/tweets/new' do
    if session[:user_id]
      erb :new
    else
      redirect '/login'
    end
  end

  #create
  post '/tweets' do
    user = User.find(session[:user_id])
    if params != nil
      tweet = Tweet.create(content: params[:content], user_id: user.id)
      redirect "/tweets/#{tweet.id}"
    else
      redirect '/tweets/new'
    end
  end

  #read
  get '/tweets/all' do
    @tweets = Tweet.all.where(user: session[:user_id])
    erb :all
  end

  #read
  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :show
  end

  #read
  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    erb :edit
  end

  #update
  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    tweet.update(content:params[:content])
    redirect "/tweets/#{tweet.id}"
  end

  #delete
  delete '/tweets/:id/delete' do
    tweet = Tweet.find(params[:id])
    tweet.delete
    redirect '/'
  end

end
