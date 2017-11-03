require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
    set :method_override, true
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
    erb :home
  end

  get '/signup' do
    redirect "/tweets" if logged_in?
    erb :signup
  end

  post '/signup' do
    # byebug
    redirect "/signup" if params.values.include?("")
    user = User.create(params[:user])
    session[:user_id] = user.id

    # byebug
    redirect "/tweets"
  end

  get '/login' do
    redirect "/tweets" if logged_in?
    erb :login
  end

  post '/login' do

  params[:username] ? user = User.find_by(:username => params[:username]) : user = User.find_by(:username => params[:user][:username])

    if user
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/"
    end
  end

  get '/logout' do
    session.destroy
    redirect '/login'
  end

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      @users = User.all
      erb :index
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    # byebug
    redirect '/tweets/new' if params[:tweet][:content] == ''
    @tweet = Tweet.create(user_id: current_user.id, content: params[:tweet][:content])
    redirect "/tweets"
  end

  get '/tweets/new' do
    if logged_in?
      erb :new
    else
      redirect "/login"
    end
  end

  get '/users/:slug' do
    @user = current_user
    @tweets = @user.tweets
    erb :show
  end

  get '/tweets/:id' do
    redirect "/login" if !logged_in?
    @tweet = Tweet.find(params[:id])
    erb :show_tweet
  end

  get '/tweets/:id/edit' do
    redirect "/login" if !logged_in?
    @tweet = Tweet.find(params[:id])
    erb :edit
  end

  delete '/tweets' do
    Tweet.find(params[:tweet][:id]).destroy
    redirect "/tweets"
  end

  patch '/tweets/:id' do
    # byebug
    @tweet = Tweet.find(params[:id])
    redirect "/tweets/#{@tweet.id}/edit" if params[:tweet][:content] == ''
    @tweet.update(content: params[:tweet][:content])
    redirect "/tweets/#{params[:id]}"
  end

end
