class CreateLocations < ActiveRecord::Migration
  def change
  	create_table :locations do |t|
  		t.string			:name
  		# t.string		:ip_address, null: false
  		t.float				:latitude
  		t.float				:longitude

  		t.references 	:user_group

  		t.timestamps
  	end
  end
end
