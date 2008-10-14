class Protein < ActiveRecord::Base
  belongs_to :gene
  
  validates_uniqueness_of :name
end