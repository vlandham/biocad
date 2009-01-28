class AddTwoAttachmentsToMicroarray < ActiveRecord::Migration
  def self.up
    rename_column :microarrays, :datafile_file_name, :normal_datafile_file_name
    rename_column :microarrays, :datafile_content_type, :normal_datafile_content_type
    rename_column :microarrays, :datafile_file_size, :normal_datafile_file_size
    rename_column :microarrays, :datafile_updated_at, :normal_datafile_updated_at
    add_column :microarrays, :cancer_datafile_file_name, :string
    add_column :microarrays, :cancer_datafile_file_size, :integer
    add_column :microarrays, :cancer_datafile_updated_at, :datetime
  end

  def self.down
    remove_column :microarrays, :cancer_datafile_updated_at
    remove_column :microarrays, :cancer_datafile_file_size
    remove_column :microarrays, :cancer_datafile_file_name
    rename_column :microarrays, :new_column_name, :column_name
    rename_column :microarrays, :normal_datafile_file_size, :datafile_file_size
    rename_column :microarrays, :normal_datafile_content_type, :datafile_content_type
    rename_column :microarrays, :normal_datafile_file_name, :datafile_file_name
  end
end
