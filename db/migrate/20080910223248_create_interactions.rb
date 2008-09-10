class CreateInteractions < ActiveRecord::Migration
  def self.up
    create_table :interactions do |t|
      t.string :source
      t.string :experiment_type

      t.timestamps
    end
  end

  def self.down
    drop_table :interactions
  end
end
