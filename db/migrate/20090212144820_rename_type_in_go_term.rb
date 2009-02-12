class RenameTypeInGoTerm < ActiveRecord::Migration
  def self.up
    rename_column :go_terms, :type, :go_type
  end

  def self.down
    rename_column :go_terms, :go_type, :type
  end
end
