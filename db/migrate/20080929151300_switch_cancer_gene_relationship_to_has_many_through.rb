class SwitchCancerGeneRelationshipToHasManyThrough < ActiveRecord::Migration
  def self.up
    drop_table :cancers_genes
    create_table :gene_types, :force => true do |t|
      t.integer :gene_id
      t.integer :cancer_id
      t.string :association
      t.timestamps
    end
  end

  def self.down
    drop_table :gene_types
    create_table "cancers_genes", :id => false, :force => true do |t|
      t.integer "gene_id"
      t.integer "cancer_id"
    end
    
  end
end
