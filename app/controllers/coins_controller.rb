class CoinsController < ApplicationController

  # GET: /coins
  get "/coins" do
    if Helper.logged_in?(session)
      @available_coins = Coin.available_coins
      erb :"/coins/index.html"
    else
      redirect '/users/login'
    end
  end

  get "/coins/new/:id" do
    if Helper.logged_in?(session) && session[:id] == Helper.current_user(session).id
      @available_coins = Coin.available_coins
      @user = Helper.current_user(session)
      @coin = @available_coins[params[:id].to_i]
      erb :"/coins/new.html"
    else
      redirect '/users/login'
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
    #binding.pry
    @coin = Coin.new
    if !params[:coin_index].empty?
      @coin = Coin.available_coins[params[:coin_index].to_i]
    end
    if Helper.logged_in?(session) && @coin.update(user_id: Helper.current_user(session).id,
      price_paid: params[:price_paid], amount: params[:amount],name: params[:coin])
      redirect "/coins"
    else
      @available_coins = Coin.available_coins
      @user = Helper.current_user(session)
      erb :"/coins/new.html"
    end
  end

  get '/coins/show/:id' do
    if Helper.logged_in?(session)
      @coin = Coin.available_coins[params[:id].to_i]
      if @coin_hash = Coin.scrape_info_page(@coin.info_url)
        @index = params[:id].to_i
        erb :"/coins/show.html"
      end
    else
      redirect "/users/login"
    end
  end

  # GET: /coins/5
  get "/coins/:id" do
    @coin = Coin.new
    @coin = Coin.find_by_id(params[:id])
    if @coin.id && @coin.user.id == Helper.current_user(session).id
      @coin_hash = Coin.scrape_info_page(@coin.info_url)
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
    if params[:amount] != "" && Helper.current_user(session).id == coin.user.id
      coin.amount = params[:amount]
      coin.price_paid = params[:price]
      coin.save
      redirect "/users/#{Helper.current_user(session).id}"
    else

    end
  end

  # DELETE: /coins/5/delete
  delete "/coins/:id/delete" do
    coin = Coin.find_by_id(params[:id])
    if Helper.current_user(session) == coin.user
      coin.destroy
      redirect "/users/#{coin.user.id}"
    else
      redirect "/coins"
    end
  end
end
