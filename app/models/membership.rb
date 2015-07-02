require_relative '../../config/environment'

class Membership < ActiveRecord::Base
  belongs_to	:user
  belongs_to 	:user_group

  # validates		:user_id, uniqueness: true # TURN ON TO SEED PROPERLY


  def inOffice?
    self.in_office
  end

  def change_state
    self.update_attribute("in_office", !self.inOffice?)
  end 

  def reset_state
    self.update_attribute("in_office", "f")
  end

  def inOffice # => NEEDS WORK! -- renaming + investigate use
    ip_address = self.user.current_ip #UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
    location = Location.create!(  name: "#{self.first_name}_location",
                                   ip:   ip_address  ) # => SHOULD NOT SAVE!!!
    self.location = location
  end

	def internet_connection?
    begin 
      true if Net::HTTP.new('www.google.com').head('/').kind_of? Net::HTTPOK
    rescue
      false
    end
  end

end
