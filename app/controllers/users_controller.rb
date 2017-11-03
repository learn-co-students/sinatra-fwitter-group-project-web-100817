class ApplicationController < Sinatra::Base
  # set :views, Proc.new {File.join('app', "views")}
  set :method_override, true
  enable :sessions
  set :session_secret, "my_fave_app"

  get '/tweets' do
    if !self.logged_in?
      redirect 'login'
    end
    erb :index
  end

  get '/signup' do

    if self.logged_in?
      redirect '/tweets'
    end
    erb :'users/create_user'
  end

  get '/login' do
    if self.logged_in?
      redirect '/tweets'
    end
    erb :'users/login'
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if !user
      redirect '/login'
    elsif user.password != params[:password]
      redirect '/login'
    end
    session[:user_id] = user.id
    redirect '/tweets'
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect '/signup'
    else
      user = User.create(params)
      session[:user_id] = user.id
    end
    redirect '/tweets'
  end

  get '/logout' do
    session.destroy
    redirect '/login'
  end

  get '/user/:id' do
    @user = User.find(params[:id])

    erb :'users/show'
  end
  
end
