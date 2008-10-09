class AddSearchTable < ActiveRecord::Migration
  def self.up
    create_table :searches, :force => true do |t|
      t.string :gene_symbol
      t.string :swissprot
      t.string :entrez
      t.string :synonym
      t.string :gene_type
      t.string :cancer_name
      t.string :interacts_with
      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end
