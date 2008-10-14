class Gene < ActiveRecord::Base
  has_many :interactions
  has_many :proteins
  acts_as_network :gene_interactions, :through => :interactions
  acts_as_network :gene_transcription_factors, :through => :transcription_factors
  has_many :cancers, :through => :gene_types
  has_many :onco_cancers, :through => :gene_types, :source => :cancer, :conditions => ['gene_types.association = ?', 'onco']
  has_many :suppressed_cancers, :through => :gene_types, :source => :cancer, :conditions => ['gene_types.association = ?', 'suppressor']
  has_many :gene_types
  has_and_belongs_to_many :pathways
  has_many :synonyms
  
  validates_uniqueness_of :gene_symbol
  
  def self.search(search,page)
    if search
      paginate(:all, :page => page, :conditions => ['gene_symbol LIKE ?', "%#{search}%"], :order => 'gene_symbol', :include => :synonyms)
    else
      self.paginate(:all, :page => page, :order => 'gene_symbol', :include => :synonyms)
    end
  end
  
  def to_s
    self.gene_symbol
  end
  
    
end
