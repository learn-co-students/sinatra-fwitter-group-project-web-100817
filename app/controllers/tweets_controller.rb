class TweetsController < ApplicationController

  get '/tweets' do
    if session[:user_id]
      @user = User.find(session[:user_id])
      erb :"tweets/index"
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if session[:user_id]
      if params[:content] != ""
        user = User.find(session[:user_id])
        tweet = Tweet.create(params)
        user.tweets << tweet
        redirect '/tweets'
      else
        redirect '/tweets/new'
      end
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if session[:user_id]
      erb :"tweets/new"
    else
      redirect '/login'
    end
  end

  get '/tweets/:tweet_id' do
    if session[:user_id]
      @tweet = Tweet.find(params[:tweet_id])
      erb :"tweets/show"
    else
      redirect '/login'
    end
  end

  patch '/tweets/:tweet_id' do
    if session[:user_id]
      if params[:content] != ""
        @tweet = Tweet.find(params[:tweet_id])
        @tweet.update(content: params[:content])
        erb :"tweets/show"
      else
        redirect "/tweets/#{params[:tweet_id]}/edit"
      end
    else
      redirect '/login'
    end
  end

  get '/tweets/:tweet_id/edit' do
    if session[:user_id]
      @tweet = Tweet.find(params[:tweet_id])
      erb :"tweets/edit"
    else
      redirect '/login'
    end
  end

  delete '/tweets/:tweet_id/delete' do
    if session[:user_id]
      tweet = Tweet.find(params[:tweet_id])
      tweet.delete if tweet.user.id == session[:user_id]
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

end