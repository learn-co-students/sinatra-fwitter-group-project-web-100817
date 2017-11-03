require './config/environment'

class ApplicationController < Sinatra::Base
  # set :views, Proc.new {File.join('app', "views")}
  set :method_override, true
  enable :sessions
  set :session_secret, "my_fave_app"

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  def logged_in?
    !self.session[:user_id]? false : true
  end

  def current_user
  end

  get '/' do
    erb :index
  end

end
