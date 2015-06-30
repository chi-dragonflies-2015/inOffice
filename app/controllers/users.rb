get '/users/:id' do
	@user = User.find_by(id: params[:id])
	erb :"/users/show"
end

post '/users/:id/change_state' do 
	user = User.find_by(id: params[:id])
	user_group = user.user_group
	# user.inOffice # => now gets current_ip and location instead of toggling self.in_office
	if user.current_ip == user_group.location.ip_address
		# user.update_attribute("in_office", !user.inOffice?)#!self.in_office)
		user.change_state
		p user.inOffice? ? "#{user.name} is IN" : "#{user.name} is OUT"
		return user.inOffice? ? "in" : "out"
	end
end