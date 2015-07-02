class CreateLocations < ActiveRecord::Migration
  def change
  	create_table :locations do |t|
  		t.string			:name
  		t.string		  :ip_address, null: false
  		t.references	:user_group

  		t.timestamps
  	end
  end
end
