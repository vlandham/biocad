class CreateUserGenes < ActiveRecord::Migration
  def self.up
    create_table :user_genes do |t|
      t.string :name
      t.integer :microarray_id
      t.integer :gene_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_genes
  end
end
