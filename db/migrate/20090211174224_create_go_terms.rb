class CreateGoTerms < ActiveRecord::Migration
  def self.up
    create_table :go_terms do |t|
      t.integer :number
      t.string :type
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :go_terms
  end
end
