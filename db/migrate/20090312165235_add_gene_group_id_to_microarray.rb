class AddGeneGroupIdToMicroarray < ActiveRecord::Migration
  def self.up
    add_column :microarrays, :gene_group_id, :integer
  end

  def self.down
    remove_column :microarrays, :gene_group_id
  end
end
