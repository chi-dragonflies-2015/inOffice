require_relative '../../config/environment'

class User < ActiveRecord::Base
	include BCrypt

  belongs_to  :user_group
  has_many    :locations, as: :locatable

	validates		:user_name, uniqueness: true
	validates 	:password_hash, presence: true

  def name
  	"#{self.first_name} #{self.last_name}"
  end	

  def inOffice?
    self.in_office
  end

  def inOffice
    self.update_attribute("in_office", !self.in_office)
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