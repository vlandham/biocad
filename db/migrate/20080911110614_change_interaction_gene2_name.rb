class ChangeInteractionGene2Name < ActiveRecord::Migration
  def self.up
    rename_column :interactions, :gene2_id, :gene_target
  end

  def self.down
    rename_column :interactions, :gene_target, :gene2_id
  end
end
