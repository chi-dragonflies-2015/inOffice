class UserGroup < ActiveRecord::Base
  has_many	:users
  has_one 	:location, as: :locatable
end
