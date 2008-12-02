class AddFieldsForPaperclip < ActiveRecord::Migration
  def self.up
    add_column :microarrays, :datafile_file_name, :string
    add_column :microarrays, :datafile_content_type, :string
    add_column :microarrays, :datafile_file_size, :integer
  end

  def self.down
    remove_column :microarrays, :datafile_file_size
    remove_column :microarrays, :datafile_content_type
    remove_column :microarrays, :datafile_file_name
  end
end
