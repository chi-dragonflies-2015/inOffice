class AddPolymorphicReferencesToLocations < ActiveRecord::Migration
  def self.up
  	add_reference 	:locations, :locatable, index: true	
  end

  def self.down
  	remove_reference 	:locations, :locatable, index: true	
  end
end
