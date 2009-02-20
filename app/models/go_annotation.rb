class GOAnnotation < ActiveRecord::Base
  belongs_to :go_term, :class_name => "GOTerm"
  belongs_to :gene
  has_and_belongs_to_many :references
  
  validates_uniqueness_of :go_term_id, :scope => :gene_id
end
