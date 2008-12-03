class AddCreatedAtPaperclip < ActiveRecord::Migration
  def self.up
    add_column :microarrays, :datafile_updated_at, :string
  end

  def self.down
    remove_column :microarrays, :datafile_updated_at
  end
end
