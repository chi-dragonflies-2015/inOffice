get '/users/:id' do
	@user = User.find_by(id: params[:id])
	@user_groups = UserGroup.all
	erb :"/users/show"
end


#--SERVICE ENDPOINTS------------------------------------->>>

post '/user_groups/:id/change_state' do 
	content_type :json

	user = User.find_by(id: session[:user_id])
	# puts "\n\n" + ">" * 10 + "#{ user }, #{ user.name }" + "\n\n"
	# user_group_membership = user.memberships.find_by(user_id: user.id)
	# user_group = user.memberships.find_by(user_id: user.id).user_group
	# user_group = user.memberships.find_by(user_id: user.id).user_group
	user_group = user.user_groups.find_by(id: params[:id])
	user_group_membership = user_group.memberships.find_by(user_group_id: params[:id])
	# puts "\n\n" + ">" * 10 + "#{ user_group }, #{ user_group.name }" + "\n\n"
	# if user_group.location.users.include?(user)
	# if user.location == user_group.location
	puts "\n\n" + ">" * 10 + "#{ user.name }.current_ip: #{ user.current_ip }" + "\n\n"
	puts "\n\n" + ">" * 10 + "#{ user_group.name }.ip_address: #{ user_group.location.ip_address }" + "\n\n"
	if user.current_ip == user_group.location.ip_address
		puts "\n\n" + ">" * 10 + "[BEFORE] #{ user.name }.in_office: #{ user_group_membership.inOffice? }" + "\n\n"
		user_group_membership.change_state
		puts "\n\n" + ">" * 10 + "[AFTER] #{ user.name }.in_office: #{ user_group_membership.inOffice? }" + "\n\n"
		p user_group_membership.inOffice? ? "#{ user.name } is IN" : "#{ user.name } is OUT"
		return user_group_membership.inOffice? ? { state: "in", errors: user.errors[:in_office] }.to_json : { state: "out", errors: user.errors[:in_office] }.to_json
	else
		user_group_membership.errors.add(:in_office, "Your current ip DOES NOT match that of this group!")
		return user_group_membership.inOffice? ? { state: "in", errors: user.errors[:in_office] }.to_json : { state: "out", errors: user.errors[:in_office] }.to_json
	end
end