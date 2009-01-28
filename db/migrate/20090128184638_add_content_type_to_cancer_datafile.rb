class AddContentTypeToCancerDatafile < ActiveRecord::Migration
  def self.up
    add_column :microarrays, :cancer_datafile_content_type, :string
  end

  def self.down
    remove_column :microarrays, :cancer_normal_datafile_content_type
  end
end
