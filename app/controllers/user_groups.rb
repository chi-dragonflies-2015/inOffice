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

post '/user_groups/new' do
	location = Location.create(params[:location])
	user_group = UserGroup.create(params[:group])
	if user_group && location
		p user_group.location
		user_group.location = location
		redirect "/user_groups/#{user_group.id}/join"
	else
		erb :"/user_groups/new"
	end
end

get '/user_groups/new' do
	@current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
	erb :"/user_groups/new"
end

get '/user_groups/:id' do 
	@user_group = UserGroup.find_by(id: params[:id])
	p @user_group.name
	@users = @user_group.users
	p @users.empty? ? "NO USERS!" : @users.reduce([]) {|arr, user| arr << user}
	erb :"/user_groups/index"
end

post '/user_groups/new' do
	location = Location.create(params[:location])
	user_group = UserGroup.create(params[:group])
	if user_group && location
		p user_group.location
		user_group.location = location
		redirect "/user_groups/#{user_group.id}/join"
	else
		erb :"/user_groups/new"
	end
end

get '/user_groups/new' do
	@current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
	erb :"/user_groups/new"
end

get '/user_groups/:id' do 
	@user_group = UserGroup.find_by(id: params[:id])
	p @user_group.name
	@users = @user_group.users
	p @users.empty? ? "NO USERS!" : @users.reduce([]) {|arr, user| arr << user}
	erb :"/user_groups/index"
end