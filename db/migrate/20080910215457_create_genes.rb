class CreateGenes < ActiveRecord::Migration
  def self.up
    create_table :genes do |t|
      t.string :gene_symbol
      t.string :swissprot
      t.string :genebank
      t.string :omim
      t.string :entrez
      t.string :orf

      t.timestamps
    end
  end

  def self.down
    drop_table :genes
  end
end
