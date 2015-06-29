class CreateUserGroups < ActiveRecord::Migration
  def change
  	create_table :user_groups do |t|
  		t.string 			:name

  		t.references	:location

  		t.timestamps
  	end
  end
end
