require_relative '../../config/environment'

class Location < ActiveRecord::Base
	include Net#::HTTP
	include JSON
  # include Faker

  belongs_to 	:locatable, polymorphic: true
  belongs_to  :user_group
  has_many    :users

  def coordinates
  	@coordinates
  end	

  # def ip_address
  # 	self.ip_address
  # end	

  def internet_connection?
    begin 
      true if Net::HTTP.new('www.google.com').head('/').kind_of? Net::HTTPOK
    rescue
      false
    end
  end

  # def current_ip
  #   if internet_connection?
  #     current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
  #     return current_ip
  #   else
  #     return "127.0.0.1" # => local_ip
  #   end
  # end

  def ip=(new_ip=nil)
    if internet_connection?
      current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
    else
      current_ip = "127.0.0.1:9393"
    end
    new_ip ? @ip_address = current_ip : @ip_address = new_ip
    # @ip_address ? @ip_address : @ip_address = Faker::Internet.ip_v4_address 
    self.ip_address = @ip_address
  	@coordinates = get_coordinates if self.internet_connection?
  end

  def get_coordinates # => requires a location -- NEEDS TO NOT!
  	p @ip_address
  	p @ip_address.class
  	uri = URI.parse("http://ip-api.com/json/" + @ip_address)
  	http = Net::HTTP.new(uri.host, uri.port)
  	request = Net::HTTP::Get.new(uri)
  	response = JSON.parse http.request(request).body # => requires Internet connection

  	self.longitude ||= response['lat']
  	self.latitude ||= response['lon']

  	coordinates ||= { latitude: self.latitude, longitude: self.longitude }
  	return coordinates
  end

end
