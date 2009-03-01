class CreateGeneGroupEntries < ActiveRecord::Migration
  def self.up
    create_table :gene_group_entries do |t|
      t.integer :gene_group_id
      t.integer :gene_id

      t.timestamps
    end
  end

  def self.down
    drop_table :gene_group_entries
  end
end
