class ChangeInteractionGene1Name < ActiveRecord::Migration
  def self.up
    rename_column :interactions, :gene1_id, :gene_id
  end

  def self.down
    rename_column :interactions, :gene_id, :gene1_id
  end
end
