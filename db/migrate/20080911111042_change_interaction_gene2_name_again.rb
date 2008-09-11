class ChangeInteractionGene2NameAgain < ActiveRecord::Migration
  def self.up
    rename_column :interactions, :gene_target, :gene_id_target
  end

  def self.down
    rename_column :interactions, :gene_id_target, :gene_target
  end
end
