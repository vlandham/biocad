class AddCreatedAtPaperclipModify < ActiveRecord::Migration
  def self.up
    remove_column :microarrays, :datafile_updated_at
    add_column :microarrays, :datafile_updated_at, :datetime
  end

  def self.down
    remove_column :microarrays, :datafile_updated_at
    add_column :microarrays, :datafile_updated_at, :string
  end
end
