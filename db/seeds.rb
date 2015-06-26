require_relative '../config/environment'

10.times do 
	first_name = Faker::Name.first_name
	last_name = Faker::Name.last_name
	user_name = Faker::Internet.user_name(first_name, %w(- _))
	email = Faker::Internet.free_email(last_name)
	User.create!(	first_name: first_name,
								last_name: 	last_name,
								user_name: 	user_name,
								email: 			email,
								password: 	"password" )
end

