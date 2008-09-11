class Cancer < ActiveRecord::Base
  has_and_belongs_to_many :genes
  has_many :experiments
  
  validates_uniqueness_of :name
end
