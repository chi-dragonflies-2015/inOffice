=begin 
	USER CAN:
		>>> CREATE UserGroup
		> JOIN UserGroup
		> CHANGE STATE for self.in_office
=end


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
	puts "\n\n" + ">" * 10 + "#{ location }" + "\n\n"
	user_group = UserGroup.create(params[:group])
	puts "\n\n" + ">" * 10 + "#{ user_group }" + "\n\n"
	user_group.location = location
	puts "\n\n" + ">" * 10 + "#{ user_group.location }" + "\n\n"
	puts "\n\n" + ">" * 10 + "#{ user_group.location.users.map{|user|user.name} }" + "\n\n"
	
	redirect "/users/#{ user.id }"
end



# JOIN A UserGroup
put '/user_groups/:id/join' do
	user = User.find_by(id: session[:user_id])
	user_group = UserGroup.find_by(id: params[:id])
	users = user_group.location.users
	if user && user_group

		if user.current_ip == user_group.location.ip_address
			users << user
			puts "\n\n" + ">" * 10 + "#{ users.map{|user|user.name} }" + "\n\n"
		else
			user_group.location.errors.add(:ip_address, "Must have the same IP address to JOIN this group!") 
			puts "\n\n" + ">" * 10 + "#{ user_group.location.errors[:ip_address] }" + "\n\n"
		end

		redirect "/user_groups/#{ user_group.id }"
	else
		erb :"/users/login"
	end
end

# SHOW JOINED UserGroup
get '/user_groups/:id' do 
	@user = User.find_by(id: session[:id])
	@user_group = UserGroup.find_by(id: params[:id])
	puts "\n\n" + ">" * 10 + @user_group.class.to_s + "\n\n"
	puts "\n\n" + ">" * 10 + @user_group.location.class.to_s + "\n\n"
	puts "\n\n" + ">" * 10 + "#{ @user_group.location.users.map{|user|user.name} }" + "\n\n"
	@users = @user_group.location.users
	erb	:"/user_groups/show"
end






#--SERVICE ENDPOINTS------------------------------------->>>

get '/user_groups/:id/get_employees' do
	user_group = UserGroup.find_by(id: params[:id])
	users = user_group.location.users #@user_group.users

	users = users.map do |user| 
		{ 	name: user.name,
				inOffice: user.inOffice?,
  			id: user.id 	}
	end
	p users
	users.to_json
end