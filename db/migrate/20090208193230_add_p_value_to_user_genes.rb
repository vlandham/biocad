class AddPValueToUserGenes < ActiveRecord::Migration
  def self.up
    add_column :user_genes, :p_value, :float
  end

  def self.down
    remove_column :user_genes, :p_value
  end
end
