class CoinsController < ApplicationController

  # GET: /coins
  get "/coins" do
    if Helper.logged_in?(session)
      redirect :"/users"
    else
      redirect '/login'
    end
  end

  # GET: /coins/new
  get "/coins/new" do
    if Helper.logged_in?(session) && session[:id] == Helper.current_user(session).id
      @available_coins = Coin.available_coins
      @user = Helper.current_user(session)
      erb :"/coins/new.html"
    else
      redirect '/users/login'
    end
  end

  # POST: /coins
  post "/coins" do
    @coin = Coin.available_coins[params[:coin_index].to_i]
    if params[:coin_index] != "" && Helper.logged_in?(session) && @coin.update(user_id: Helper.current_user(session).id, price_paid: params[:price_paid], amount: params[:amount])
      redirect "/coins"
    else
      @available_coins = Coin.available_coins
      @user = Helper.current_user(session)
      erb :"/coins/new.html"
    end
  end

  # GET: /coins/5
  get "/coins/:id" do
    @coin = Coin.find_by_id(params[:id])
    @coin_hash = Coin.scrape_info_page(@coin.name)
    if @coin.user.id == Helper.current_user(session).id
      erb :"/coins/show.html"
    else
      redirect '/users/login'
    end
  end

  # GET: /coins/5/edit
  get "/coins/:id/edit" do
    #binding.pry
    @coin = Coin.find_by_id(params[:id])
    if @coin.user.id == Helper.current_user(session).id
      erb :"/coins/edit.html"
    else
      redirect '/users/login'
    end
  end

  # PATCH: /coins/5
  patch "/coins/:id" do
    coin = Coin.find_by_id(params[:id])
    binding.pry
    if params[:amount] != "" && Helper.current_user(session).id == coin.user.id
      params[:buy].to_i == 1 ? coin.amount += params[:amount].to_f : coin.amount -= params[:amount].to_f
      #binding.pry
      params[:current_price].to_f > 0 ? coin.price_paid = params[:current_price] : coin.price_paid = params[:price]
      #binding.pry
      coin.save
      redirect "/users"
    else

    end
  end

  # DELETE: /coins/5/delete
  delete "/coins/:id/delete" do
    redirect "/coins"
  end
end
