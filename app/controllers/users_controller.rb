class UsersController < ApplicationController


  get '/users/login' do
    #binding.pry
    if !Helper.logged_in?(session)
     erb :'users/login'
    else
     redirect "/users"
   end
  end

  post '/users/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/users'
    else
      redirect '/users/login'
    end
  end

  # GET: /users
  get "/users" do
    if Helper.logged_in?(session) && session[:id] == Helper.current_user(session).id
      @user = Helper.current_user(session)
      Coin.get_current_price_for_coins(@user)
      erb :"/users/index.html"
    else
      redirect 'users/login'
    end
  end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    #binding.pry
    user = User.new(:username => params[:username], :password => params[:password])
    if user.save
      session[:id] = user.id
      redirect '/users'
    else
      redirect "/users/new"
    end
  end

  get 'users/logout' do
    if Helper.logged_in?(session)
        session[:id] = nil
        redirect '/login'
    else
        redirect '/login'
    end
  end

  # GET: /users/5
  get "/users/:id" do
    erb :"/users/show.html"
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    erb :"/users/edit.html"
  end

  # PATCH: /users/5
  patch "/users/:id" do
    redirect "/users/:id"
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    redirect "/users"
  end
end
