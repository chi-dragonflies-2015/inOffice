class UserGroup < ActiveRecord::Base
  has_one	 	:location
  has_many 	:memberships
 	has_many 	:users, through: :memberships
end
