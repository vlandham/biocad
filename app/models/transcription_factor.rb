class TranscriptionFactor < ActiveRecord::Base
  belongs_to :gene, :class_name => 'Gene', :foreign_key => 'gene_id'
  belongs_to :gene_target, :class_name => 'Gene', :foreign_key => 'gene_id_target'
end