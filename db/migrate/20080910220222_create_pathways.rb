class CreatePathways < ActiveRecord::Migration
  def self.up
    create_table :pathways do |t|
      t.string :name
      t.text :description
      t.string :source

      t.timestamps
    end
  end

  def self.down
    drop_table :pathways
  end
end
