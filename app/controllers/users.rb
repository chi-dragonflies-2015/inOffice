get '/users/:id' do
	@user = User.find_by(id: params[:id])
	@user_groups = UserGroup.all
	erb :"/users/show"
end


#--SERVICE ENDPOINTS------------------------------------->>>

