class User < ActiveRecord::Base
  has_many :coins
  has_secure_password
  validates :username, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  def coinfolio_value
    value = 0.0
    self.coins.each {|coin|
      value += coin.amount * coin.current_price
    }
    value.round(2)
  end
end
