class CreateGoAnnotations < ActiveRecord::Migration
  def self.up
    create_table :go_annotations do |t|
      t.integer :go_term_id
      t.integer :gene_id

      t.timestamps
    end
  end

  def self.down
    drop_table :go_annotations
  end
end
