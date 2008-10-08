class Cancer < ActiveRecord::Base
  has_many :gene_types #needed for the through to work?
  has_many :genes, :through => :gene_types
  has_many :onco_genes, :through => :gene_types, :source => :gene, :conditions => ['gene_types.association = ?', 'onco']
  has_many :suppressor_genes, :through => :gene_types, :source => :gene, :conditions => ['gene_types.association = ?', 'suppressor']
  has_many :experiments
  
  validates_uniqueness_of :name
  
  def self.search(search,page)
    if search
      paginate(:all, :page => page, :conditions => ['name LIKE ?', "%#{search}%"], :order => 'name')
    else
      self.paginate(:all, :page => page, :order => 'name')
    end
  end
  
  
  def to_s
    self.name
  end
end
