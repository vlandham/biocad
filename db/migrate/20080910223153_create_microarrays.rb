class CreateMicroarrays < ActiveRecord::Migration
  def self.up
    create_table :microarrays do |t|
      t.integer :experiment_id
      t.string :filename

      t.timestamps
    end
  end

  def self.down
    drop_table :microarrays
  end
end
