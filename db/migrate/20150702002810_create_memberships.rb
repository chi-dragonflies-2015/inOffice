class CreateMemberships < ActiveRecord::Migration
  def change
  	create_table :memberships do |t|
  		t.references	:user
  		t.references	:user_group
  		t.boolean			:in_office, default: false

  		t.timestamps
  	end
  end
end
