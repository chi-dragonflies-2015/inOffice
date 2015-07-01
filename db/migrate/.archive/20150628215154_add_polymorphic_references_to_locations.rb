class AddPolymorphicReferencesToLocations < ActiveRecord::Migration
  def up
    change_table :locations do |t|
      t.references :locatable, :polymorphic => true
    end
  end

  def down
    change_table :locations do |t|
      t.remove_references :locatable, :polymorphic => true
    end
  end
end
