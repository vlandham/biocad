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
      if search.include?(';')
        exact_search(search,page)
      else
        like_search(search,page)
      end
    else
      self.paginate(:all, :page => page, :order => 'gene_symbol', :include => :synonyms)
    end
  end
  
  def self.exact_search(search,page)
    genes = search.upcase.split(/\s*;\s*/)
    self.find(:all, :conditions => [ "gene_symbol IN (?)", genes])
  end
  
  def self.like_search(search,page)
    self.paginate(:all, :page => page, :conditions => ['gene_symbol LIKE ?', "%#{search}%"], :order => 'gene_symbol', :include => :synonyms)
  end
  
  def to_s
    self.gene_symbol
  end
  
    
end
