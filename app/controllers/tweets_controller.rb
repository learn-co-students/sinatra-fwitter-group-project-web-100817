class ApplicationController < Sinatra::Base
  # set :views, Proc.new {File.join('app', "views")}
  set :method_override, true
  enable :sessions
  set :session_secret, "my_fave_app"

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/tweets/new' do
    if !logged_in?
      redirect '/login'
    end
    @user = User.find(session[:user_id])
    erb :'tweets/create_tweet'
  end

  post '/tweets/new' do
    if params[:content] == ""
      redirect '/tweets/new'
    else
    @post = Tweet.create(params)
    redirect "/tweets/#{@post.id}"
    end
  end

  get '/tweets/:id' do
    if !logged_in?
      redirect '/login'
    end
    @tweet = Tweet.find(params[:id])
    @user = User.find(@tweet.user_id)

    erb :'tweets/show_tweet'
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    if !logged_in?
      redirect '/login'
    elsif @tweet.user.id != session[:user_id]
      redirect '/tweets'
    end
    erb :'tweets/edit_tweet'
  end

  post '/tweets/:id/edit' do
    if params[:content] == ""
      redirect "/tweets/#{params[:id]}/edit"
    end
    tweet = Tweet.find(params[:id])
    tweet.content = params[:content]
    tweet.save
    redirect "/tweets/#{tweet.id}"
  end


  post '/tweets/:id/delete' do
    tweet = Tweet.find(params[:id])
    if session[:user_id] != tweet.user.id
      redirect '/tweets'
    end
    tweet.destroy
    redirect "/tweets"
  end

end
