get '/users/:id' do
	@user = User.find_by(id: params[:id])
	erb :"/users/show"
end

post '/users/:id/change_state' do 
	content_type :json

	user = User.find_by(id: params[:id])
	user_group = user.user_group
	if user.current_ip == user_group.location.ip_address
		user.change_state
		p user.inOffice? ? "#{user.name} is IN" : "#{user.name} is OUT"
		return user.inOffice? ? { state: "in", errors: user.errors[:in_office] }.to_json : { state: "out", errors: user.errors[:in_office] }.to_json
	else
		user.errors.add(:in_office, "Your current ip DOES NOT match that of this group!")
		return user.inOffice? ? { state: "in", errors: user.errors[:in_office] }.to_json : { state: "out", errors: user.errors[:in_office] }.to_json
	end
end