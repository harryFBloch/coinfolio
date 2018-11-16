class Coin < ActiveRecord::Base
  belongs_to :user
  validates :price_paid, :amount, presence: true

  COIN_MARKET_CAP_URL = "https://coinmarketcap.com/"

  def self.get_current_price_for_coins(user)
    prices = self.scrape_top_100_coins
    user.coins.each do |coin|
      prices.each do |coin_hash|
        if coin.name == coin_hash[:name]
          coin.current_price = coin_hash[:current_price]
          coin.save
      end
    end
  end
end

  def self.scrape_top_100_coins
      doc = Nokogiri::HTML(open(COIN_MARKET_CAP_URL))
       coin_array = doc.css("tbody tr").each_with_index.map { |coin_container, index|
         name = coin_container.css("a.currency-name-container").text.strip
         link = coin_container.css("a.currency-name-container").attr("href").value
         price = coin_container.css("a.price").attr("data-usd").value.strip
         #puts "#{index + 1}. #{name}-$#{price}"
         {:name => name, :current_price => price}
       }
  end

  def self.scrape_info_page(name)
  doc = Nokogiri::HTML(open(COIN_MARKET_CAP_URL + "currencies/" + name.downcase + "/"))
  info_hash = {}
  info_hash[:percent_change] = doc.css(".details-panel-item--price .h2 span").text
  info_hash[:btc_price] = doc.css(".details-panel-item--price .text-gray span").text.strip
  info_hash[:ticker] = doc.css("span.h3").text.gsub("(","").gsub(")","")
  market_cap_array = doc.css("div.coin-summary-item")

  market_cap_array.each {|coin_container|
    price_type = coin_container.css("h5.coin-summary-item-header").text
    case price_type
    when "Market Cap"
      info_hash[:usd_market_cap] = coin_container.css("div.coin-summary-item-detail span span")[0].text
      info_hash[:btc_market_cap] = coin_container.css("div.coin-summary-item-detail span span")[2].text.gsub("\n", "")
    when "Volume (24h)"
      info_hash[:volume_usd_24hr] = coin_container.css("div.coin-summary-item-detail span span")[0].text
      info_hash[:volume_btc_24hr] = coin_container.css("div.coin-summary-item-detail span span")[2].text.gsub("\n", "")
    when "Circulating Supply"
      info_hash[:circulating_supply_btc] = coin_container.css("div.coin-summary-item-detail span").text.strip
    when "Max Supply"
      info_hash[:max_supply] = coin_container.css("div.coin-summary-item-detail span").text.strip
    end
  }
  info_hash[:graph_time] = "24h"
  info_hash[:graph_type] = "light"
  info_hash
end

  def self.available_coins
    coin_array = self.scrape_top_100_coins
    coin_array.map {|coin_hash| Coin.new(coin_hash)}
  end

end
