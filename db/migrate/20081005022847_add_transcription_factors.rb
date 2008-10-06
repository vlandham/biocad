class AddTranscriptionFactors < ActiveRecord::Migration
  def self.up
    create_table :transcription_factors, :force => true do |t|
      t.integer :gene_id
      t.integer :gene_id_target
      t.string :type
      t.timestamps
    end
  end

  def self.down
    drop_table :transcription_factors
  end
end
