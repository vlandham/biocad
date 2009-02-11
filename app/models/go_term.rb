class GOTerm < ActiveRecord::Base
  has_many :go_annotations
  has_many :genes, :through => :go_annotations
end
