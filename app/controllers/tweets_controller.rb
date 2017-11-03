class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/index'
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.all.find {|user| user.slug == params[:slug]}
    @tweets = @user.tweets
    erb :'/tweets/mytweets'
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect '/tweets/new'
    else
      tweet = Tweet.new(params)
      tweet.user = current_user
      tweet.save
      redirect "/tweets/#{tweet.id}"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
    # && current_user == @tweet.user
      @tweet = Tweet.find(params[:id])
      erb :'tweets/edit'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if params[:tweet][:content].empty?
      redirect "/tweets/#{tweet.id}/edit"
    else
      tweet.update(params[:tweet])
      redirect "/tweets/#{tweet.id}"
    end
  end

  delete '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if tweet.user_id != session[:user_id]
      redirect '/tweets'
    else
      Tweet.delete(params[:id])
      redirect '/tweets'
    end
  end
end
