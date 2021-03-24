require './config/environment'
class User_controller < ApplicationController

get '/users/:slug' do
   @tweets=Tweet.all.select{|x|x.user_id == params[:id].to_i}
    erb :'users/show'
end
end
