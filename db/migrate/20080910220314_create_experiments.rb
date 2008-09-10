class CreateExperiments < ActiveRecord::Migration
  def self.up
    create_table :experiments do |t|
      t.integer :cancer_id
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :experiments
  end
end
