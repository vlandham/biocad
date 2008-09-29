class Gene < ActiveRecord::Base
  acts_as_network :gene_interactions, :through => :interactions
  
  has_many :cancers, :through => :gene_types
  has_many :gene_types
  has_and_belongs_to_many :pathways
  has_many :synonyms
  
  validates_uniqueness_of :gene_symbol
    
end
