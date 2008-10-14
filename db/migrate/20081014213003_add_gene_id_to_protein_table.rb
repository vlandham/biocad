class AddGeneIdToProteinTable < ActiveRecord::Migration
  def self.up
    add_column :proteins, :gene_id, :integer
  end

  def self.down
    remove_column :proteins, :gene_id
  end
end
