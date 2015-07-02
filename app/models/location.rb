require_relative '../../config/environment'

class Location < ActiveRecord::Base

  belongs_to 	:user_group

  def internet_connection?
    begin 
      true if Net::HTTP.new('www.google.com').head('/').kind_of? Net::HTTPOK
    rescue
      false
    end
  end

  def ip=(new_ip=nil)
    if internet_connection?
      current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
    else
      current_ip = "127.0.0.1:9393"
    end
    new_ip.nil? ? @ip = current_ip : @ip = new_ip
    self.ip_address = @ip
  end

  def get_coordinates # => requires a location -- NEEDS TO NOT!
  	if internet_connection?
	  	uri = URI.parse("http://ip-api.com/json/#{self.ip_address}")
	  	http = Net::HTTP.new(uri.host, uri.port)
	  	request = Net::HTTP::Get.new(uri)
	  	response = JSON.parse http.request(request).body # => requires Internet connection

	  	p response
	  	@longitude ||= response['lat']
	  	@latitude ||= response['lon']

	  	coordinates ||= { latitude: @latitude, longitude: @longitude }
	  	return coordinates
	  else
	  	return "Internet connection is required!"
	  end
  end

end
