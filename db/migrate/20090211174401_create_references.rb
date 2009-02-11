class CreateReferences < ActiveRecord::Migration
  def self.up
    create_table :references do |t|
      t.integer :number

      t.timestamps
    end
    
    create_table :go_annotations_references, :force => true, :id => false do |t|
      t.integer :reference_id
      t.integer :go_annotation_id
    end
  end

  def self.down
    drop_table :references
    drop_table :go_annotations_references
  end
end
