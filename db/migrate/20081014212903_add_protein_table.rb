class AddProteinTable < ActiveRecord::Migration
  def self.up
    create_table :proteins, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :proteins
  end
end
