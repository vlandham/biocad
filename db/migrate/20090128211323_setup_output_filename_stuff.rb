class SetupOutputFilenameStuff < ActiveRecord::Migration
  def self.up
    rename_column :microarrays, :filename, :output_file_name
    add_column :microarrays, :name, :string
  end

  def self.down
    remove_column :microarrays, :name
    rename_column :microarrays, :output_file_name
  end
end
