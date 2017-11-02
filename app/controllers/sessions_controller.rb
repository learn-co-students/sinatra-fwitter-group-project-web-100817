class SessionsController < ApplicationController

  get '/signup' do
    if session[:user_id] == nil
      erb :signup
    else
      redirect '/tweets'
    end
  end

  post '/signup' do
    if params[:username] != "" && params[:email] != "" && params[:password] != ""
      user = User.create(params)
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if session[:user_id] == nil
      erb :login
    else
      redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      erb :login
    end
  end

  get '/logout' do
    session[:user_id] = nil
    redirect '/login'
  end
  
end