get '/user_groups/:id' do 
	@user_group = UserGroup.find_by(id: params[:id])
	p @user_group.name
	@users = @user_group.users
	p @users.empty? ? "NO USERS!" : @users.reduce([]) {|arr, user| arr << user}
	erb :"/user_groups/index"
end

get '/user_groups/:id/join' do
	user = User.find_by(id: session[:user_id])
	if user
		user_group = UserGroup.find_by(id: params[:id])
		user_group.users << user
		redirect "/user_groups/#{params[:id]}"
	else
		erb :"/users/login"
	end
end

get '/user_groups/:id/get_employees' do
	@user_group = UserGroup.find_by(id: params[:id])
	@users = @user_group.users

	@users = @users.map do |user| 
		{ 	name: user.name,
				inOffice: user.inOffice?,
  			id: user.id 	}
	end
	p @users
	@users.to_json
end

post '/users/:id/change_state' do 
	user = User.find_by(id: params[:id])
	user.inOffice # => gets current_up and location
	if user.location.ip_address == user_group.location.ip_address
		user.update_attribute("in_office", !self.in_office)
	end
	p user.inOffice?
end

