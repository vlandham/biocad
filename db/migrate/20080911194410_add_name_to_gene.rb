class AddNameToGene < ActiveRecord::Migration
  def self.up
    add_column :genes, :name, :string
  end

  def self.down
    remove_column :genes, :name
  end
end
