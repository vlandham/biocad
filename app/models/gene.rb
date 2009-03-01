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
  has_many :go_annotations, :class_name => "GOAnnotation"
  has_many :go_terms, :through => :go_annotations, :class_name => "GOTerm", :order => "go_type DESC, name ASC"
  
  # Gene group connection
  has_many :gene_group_entries
  has_many :gene_groups, :through :gene_group_entry
  
  validates_uniqueness_of :gene_symbol
  
  def self.search(search,page)
    conditions = nil
    if search
      if search.include?(';')
        genes = search.upcase.split(/\s*;\s*/)
        conditions = [ "gene_symbol IN (?)", genes]
      else
       conditions = ['gene_symbol LIKE ?', "#{search}%"]
      end
    else
    end
    options = {:page => page, :order => 'gene_symbol', :include => [:synonyms, :gene_interactions_out, :gene_interactions_in]}
    options[:conditions] = conditions if conditions

    self.paginate(:all, options)
  end
  
  # def self.exact_search(search,page)
  #   
  #   self.find(:all, :conditions => , :include => :synonyms)
  # end
  # 
  # def self.like_search(search,page)
  #   self.paginate(:all, :page => page, :conditions => , :order => 'gene_symbol', :include => :synonyms)
  # end
  
  def to_s
    self.gene_symbol
  end
    
end
