class CreateIntermediateJoinTables < ActiveRecord::Migration
  def self.up
    create_table :genes_pathways, :force => true, :id => false do |t|
      t.integer :gene_id
      t.integer :pathway_id
    end
    create_table :cancers_genes, :force => true, :id => false do |t|
      t.integer :gene_id
      t.integer :cancer_id
    end
    create_table :genes_interactions, :force => true, :id => false do |t|
      t.integer :gene_id
      t.integer :interaction_id
    end
  end

  def self.down
    drop_table :genes_interactions
    drop_table :cancers_genes
    drop_table :genes_pathways
  end
end
