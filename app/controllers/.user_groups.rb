get '/user_groups/:id/join' do
	user = User.find_by(id: session[:user_id])
	if user





		redirect "/user_groups/#{params[:id]}"
		# user_group = UserGroup.find_by(id: params[:id])
		# # user_group.users << user
		# # user.reset_state
		# p user_group.location
		# user_group.location.users << user
		# user.location = user_group.location # => alters "locatable_type" to "User"
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

# post '/user_groups/new' do
# 	location = Location.create(params[:location])
# 	user_group = UserGroup.create(params[:group])#.location = location
# 	if user_group.valid? && location.valid? #location && user_group




# 		redirect "/user_groups/#{user_group.id}/join"
# 		# user_group.location = location # => Location defined at inception!
# 		# # user_group.location = Location.create(params[:location])
# 		# p user_group.location
# 	else
# 		erb :"/user_groups/new"
# 	end
# end

get '/user_groups/new' do
	user = User.find_by(id: session[:user_id])
	@current_ip = user.current_ip
	# @current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
	erb :"/user_groups/new"
end


post '/user_groups/new' do
	p params
	@user = User.find_by(id: session[:user_id])
	@location = Location.create(params[:location])
	@user_group = UserGroup.create(params[:group])
	@user_groups = UserGroup.all
	p ">" * 10 + @user.name
	p ">" * 10 + @location.name
	p ">" * 10 + @user_group.name

	erb :"/users/show"
	# return "Hello"
		# redirect "/users/#{session[:user_id]}"
	# if user && user_group.valid? && location.valid?




		# redirect "/user_groups/#{user_group.id}/join" # NO "AUTO-JOIN"
		# p user_group.location
		# user_group.location = location
	# else
		# erb :"/user_groups/new"
	# end
end

get '/user_groups/:id' do 
	# @user = User.find_by(id: session[:user_id])
	@user_group = UserGroup.find_by(id: params[:id])
	p @user_group
	# p @user_group.name
	# @users = @user_group.users
	# p @user_group.location
	# @users = @user_group.location.users # !!!
	# p @users.empty? ? "NO USERS!" : @users.reduce([]) {|arr, user| arr << user}
	# erb :"/user_groups/index"
end

get '/user_groups/new' do
	user = User.find_by(id: session[:user_id])
	@current_ip = user.current_ip
	erb :"/user_groups/new"
	# @current_ip = UDPSocket.open {|s| s.connect('64.233.187.99', 1); s.addr.last }
end

get '/user_groups/:id' do 

	"Hello"


	# p @users.empty? ? "NO USERS!" : @users.reduce([]) {|arr, user| arr << user}
	# erb :"/user_groups/index"
	# @user_group = UserGroup.find_by(id: params[:id])
	# p @user_group.name
	# # @users = @user_group.users
	# @users = @user_group.location.users
end