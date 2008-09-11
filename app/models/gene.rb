class Gene < ActiveRecord::Base
  acts_as_network :gene_interactions, :through => :interactions
  
  has_and_belongs_to_many :cancers
  has_and_belongs_to_many :pathways
  has_many :synonyms
  
  validates_uniqueness_of :gene_symbol
end
