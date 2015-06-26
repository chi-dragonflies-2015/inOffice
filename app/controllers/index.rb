get '/' do
	erb :"/index"
end

get '/login' do 	
	erb :"/users/login"
end

post '/login' do
	user = User.authenticate(params[:user_name], params[:password])
	if user.id
		session[:user_id] = user.id
		redirect "/users/#{user.id}"
	else
		@errors = user.errors.messages
		p @errors
		erb :"/users/login"
	end
end

get '/users/:id' do
	@user = User.find_by(id: params[:id])
	erb :"/users/show"
end

delete '/logout' do
	session[:user_id] = nil
	redirect '/'
end

get '/signup' do 	
	erb :"/users/signup"
end

post '/signup' do
	user = User.create(params[:signup])
	if user.valid?
		redirect '/login'
	else
		erb :"/users/signup"
	end
end