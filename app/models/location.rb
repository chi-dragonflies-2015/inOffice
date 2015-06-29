require_relative '../../config/environment'

class Location < ActiveRecord::Base
	include Net#::HTTP
	include JSON

  belongs_to 	:locatable, polymorphic: true

  def coordinates
  	@coordinates
  end	

  def ip_address
  	@ip_address
  end	

  def ip=(new_ip=nil)
    current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
    new_ip ? @ip_address = current_ip : @ip_address = new_ip
    self.ip_address = @ip_address
  	@coordinates = get_coordinates
  end

  def get_coordinates
  	p @ip_address
  	p @ip_address.class
  	uri = URI.parse("http://ip-api.com/json/" + @ip_address)
  	http = Net::HTTP.new(uri.host, uri.port)
  	request = Net::HTTP::Get.new(uri)
  	response = JSON.parse http.request(request).body

  	self.longitude ||= response['lat']
  	self.latitude ||= response['lon']

  	coordinates ||= { latitude: self.latitude, longitude: self.longitude }
  	return coordinates
  end

end
