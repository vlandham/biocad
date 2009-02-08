class AddStatusFieldsToMicroarray < ActiveRecord::Migration
  def self.up
    add_column :microarrays, :completed_at, :datetime
    add_column :microarrays, :return_value, :integer
    add_column :microarrays, :return_message, :text
  end

  def self.down
    remove_column :microarrays, :completed_at
    remove_column :microarrays, :return_value
    remove_column :microarrays, :return_message
  end
end
