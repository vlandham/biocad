class Gene < ActiveRecord::Base
  acts_as_network :gene_interactions, :through => :interactions
  
  has_many :cancers, :through => :gene_types
  has_many :onco_cancers, :through => :gene_types, :source => :cancer, :conditions => ['gene_types.association = ?', 'onco']
  has_many :suppressed_cancers, :through => :gene_types, :source => :cancer, :conditions => ['gene_types.association = ?', 'suppressor']
  has_many :gene_types
  has_and_belongs_to_many :pathways
  has_many :synonyms
  
  validates_uniqueness_of :gene_symbol
  
  
  def to_s
    self.gene_symbol
  end
  
    
end
