class UsersController < ApplicationController


  get '/users/login' do
    #binding.pry
    if !Helper.logged_in?(session)
      #binding.pry
      @true = true
     erb :'users/login'
    else
     redirect "/users/#{Helper.current_user(session).id}"
   end
  end

  post '/users/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect "/users/#{Helper.current_user(session).id}"
    else
      redirect '/users/login'
    end
  end

  # GET: /users
  # get "/users" do
  #   if Helper.logged_in?(session) && session[:id] == Helper.current_user(session).id
  #     @user = Helper.current_user(session)
  #     Coin.get_current_price_for_coins(@user)
  #     erb :"/users/index.html"
  #   else
  #     redirect 'users/login'
  #   end
  # end

  # GET: /users/new
  get "/users/new" do
    erb :"/users/new.html"
  end

  # POST: /users
  post "/users" do
    #binding.pry
    @user = User.new(:username => params[:username], :password => params[:password])
    if @user.save
      session[:id] = @user.id
      redirect "/coins"
    else
      erb :"/users/new.html"
    end
  end

  get '/users/logout' do
    if Helper.logged_in?(session)
        session[:id] = nil
        redirect '/users/login'
    else
        redirect '/users/login'
    end
  end

  # GET: /users/5
  get "/users/:id" do
    if Helper.logged_in?(session) && session[:id] == Helper.current_user(session).id
      @user = Helper.current_user(session)
      Coin.get_current_price_for_coins(@user)
      #binding.pry
      erb :"/users/show.html"
    else
      redirect 'users/login'
    end
  end

  # GET: /users/5/edit
  get "/users/:id/edit" do
    @user = User.find_by_id(params[:id])
    if @user == Helper.current_user(session)
      erb :"/users/edit.html"
    else
      redirect "/"
    end
  end

  # PATCH: /users/5
  patch "/users/:id" do
    @user = User.find_by_id(params[:id])
    if @user == Helper.current_user(session) && params[:password] == params[:re_password]
      @user.update(password: params[:password])
      redirect "/users/:id"
    else
      redirect "/"
    end
  end

  # DELETE: /users/5/delete
  delete "/users/:id/delete" do
    user = User.find_by_id(params[:id])
    if user == Helper.current_user(session)
      user.coins.each {|coin| coin.destroy}
      user.destroy
      session[:id] = nil
      redirect "/"
    else
      redirect "/"
    end
  end
end
