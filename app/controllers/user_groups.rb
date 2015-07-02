# GET "NEW UserGroup" FORM
get '/user_groups/new' do
	user = User.find_by(id: session[:user_id])
	@current_ip = user.current_ip
	erb :"/user_groups/new"
end

# CREATE NEW UserGroup
post '/user_groups/new' do
	user = User.find_by(id: session[:user_id])

	location = Location.create(params[:location])
	user_group = UserGroup.create(params[:group])
	user_group.location = location
	
	redirect "/users/#{ user.id }"
end



# JOIN A UserGroup
get '/user_groups/:id/join' do
	user = User.find_by(id: session[:user_id])
	puts "\n\n" + ">" * 10 + "#{ user }, #{ user.name }" + "\n\n"
	user_group = UserGroup.find_by(id: params[:id])
	puts "\n\n" + ">" * 10 + "#{ user_group }, #{ user_group.name }" + "\n\n"
	if user && user_group
		new_membership = Membership.create(user_id: user.id, user_group_id: user_group.id)
		puts "\n\n" + ">" * 10 + "#{ new_membership }, #{ new_membership.valid? }" + "\n\n"

		redirect "/user_groups/#{ user_group.id }"
	else
		erb :"/users/login"
	end
end

# SHOW JOINED UserGroup
get '/user_groups/:id' do 
	@user = User.find_by(id: session[:id])
	@user_group = UserGroup.find_by(id: params[:id])
	@users = @user_group.memberships
	erb	:"/user_groups/show"
end






#--SERVICE ENDPOINTS------------------------------------->>>

get '/user_groups/:id/get_employees' do
	user_group = UserGroup.find_by(id: params[:id])
	users = user_group.users #@user_group.users

	users = users.map do |user| 
		{ 	name: user.name,
				inOffice: user.memberships.find_by(user_group_id: params[:id]).inOffice?,
  			id: user.id 	}
	end
	p users
	users.to_json
end

post '/user_groups/:id/change_state' do 
	content_type :json

	user = User.find_by(id: session[:user_id])
	user_group = user.user_groups.find_by(id: params[:id])
	user_group_membership = user_group.memberships.find_by(user_group_id: params[:id])
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