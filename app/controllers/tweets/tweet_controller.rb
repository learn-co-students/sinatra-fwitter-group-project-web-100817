require './config/environment'
class Tweet_controller < ApplicationController
  def current_tweet
    Tweet.find(params[:id].to_i)
  end

  get '/tweets' do
    if logged_in?
      erb :'tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
    erb :'tweets/create_tweet'
  else
      redirect '/login'
    end

  end

  post '/tweets' do
    if !params[:content].empty?
      tweet = Tweet.new(params)
      tweet.save
      user = User.find(logged_in?)
      user.tweets << tweet
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    if !params[:content].empty?
      current_tweet.update(content: params[:content])
      redirect "/tweets/#{current_tweet.id}"
    else
      redirect "/tweets/#{current_tweet.id}/edit"
    end
  end

  delete '/tweets/:id' do
    if current_tweet.user_id == current_user.id
      @tweet = current_tweet
      current_tweet.destroy
      erb :'tweets/deleted'
    else
      redirect '/tweets'
    end
    end
end
