require_relative '../../config/environment'

class User < ActiveRecord::Base
	include BCrypt

 	has_many 	:memberships
 	has_many 	:user_groups, through: :memberships

 	def name
  	"#{self.first_name} #{self.last_name}"
  end	

  def internet_connection?
    begin 
      true if Net::HTTP.new('www.google.com').head('/').kind_of? Net::HTTPOK
    rescue
      false
    end
  end

  def current_ip
    if internet_connection?
      current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
      return current_ip
    else
      return "127.0.0.1:9393" # => local_ip
    end
  end


  #--AUTHENTICATION---------------------------------->>>

  def password
    @password ||= Password.new(self.password_hash)
  end

  def password=(text_password)
    if text_password.length > 6
      @password = Password.create(text_password)
      self.password_hash = @password
    else
      nil
    end
  end

  def self.authenticate(user_name, text_password)
    user = User.find_by(user_name: user_name)
    if user && user.password == text_password
      user
    else
      user = User.new
      user.errors.set(:login, "Incorrect username/password combination")
      return user
    end
  end

end
