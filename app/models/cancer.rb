class Cancer < ActiveRecord::Base
  has_many :genes, :through => :gene_types

  has_many :experiments
  
  validates_uniqueness_of :name
  
  def to_s
    self.name
  end
end
