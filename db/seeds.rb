require_relative '../config/environment'

# USERS
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

# USER_GROUPS & LOCATIONS
5.times do 
	location_name = Faker::Company.name
	ip = Faker::Internet.ip_v4_address
	location = Location.create!(	name: location_name,
																ip: 	ip )

	group_name = Faker::Commerce.department
	UserGroup.create!(	name: group_name	).location = location
end

# MEMBERSHIPS
10.times do
	membership = Membership.create(user: User.find( rand(1..10) ), user_group: UserGroup.find( rand(1..5) ))
	unless membership.valid?
		redo
	end
end
