class ChangeInteractionsToThrough < ActiveRecord::Migration
  def self.up
    drop_table :genes_interactions
    add_column :interactions, :gene1_id, :integer
    add_column :interactions, :gene2_id, :integer
  end

  def self.down
    remove_column :interactions, :gene1_id
    remove_column :interactions, :gene2_id
    create_table "genes_interactions", :id => false, :force => true do |t|
      t.integer "gene_id"
      t.integer "interaction_id"
    end
    
  end
end
