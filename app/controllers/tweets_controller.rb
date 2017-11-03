class TweetsController < ApplicationController

  get '/tweets' do
    @tweets = Tweet.all
    erb :'/tweets/index'
  end

  get '/mytweets' do
    if logged_in?
      @tweets = current_user.tweets
      erb :'/tweets/mytweets'
    else
      redirect '/login'
    end
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
      erb :'tweets/new'
    else
      tweet = Tweet.new(params)
      tweet.user = current_user
      tweet.save
      redirect "/tweets/#{tweet.id}"
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    erb :'tweets/show'
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    if logged_in? && current_user == @tweet.user
      erb :'tweets/edit'
    else
      redirect '/tweets'
    end
  end

  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    tweet.update(params[:tweet])
    redirect "/tweets/#{tweet.id}"
  end

  delete '/tweets/:id' do
    Tweet.delete(params[:id])
    redirect '/tweets'
  end
end
