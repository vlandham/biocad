class CreateCancers < ActiveRecord::Migration
  def self.up
    create_table :cancers do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :cancers
  end
end
