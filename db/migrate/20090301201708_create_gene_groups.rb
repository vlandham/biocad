class CreateGeneGroups < ActiveRecord::Migration
  def self.up
    create_table :gene_groups do |t|
      t.string :name
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gene_groups
  end
end
