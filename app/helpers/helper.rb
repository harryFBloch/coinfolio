require 'sinatra/base'
class Helper

  def self.logged_in?(session)
    !!session[:id]
  end

  def self.current_user(session)
    User.find(session[:id])
  end

end
