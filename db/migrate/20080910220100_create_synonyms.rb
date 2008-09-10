class CreateSynonyms < ActiveRecord::Migration
  def self.up
    create_table :synonyms do |t|
      t.integer :gene_id
      t.string :synonym

      t.timestamps
    end
  end

  def self.down
    drop_table :synonyms
  end
end
