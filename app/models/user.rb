class User < ActiveRecord::Base
  has_many :coins
  has_secure_password
  validates :username, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
