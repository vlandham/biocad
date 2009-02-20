class GOTerm < ActiveRecord::Base
  has_many :go_annotations, :class_name => "GOAnnotation"
  has_many :genes, :through => :go_annotations
  validates_uniqueness_of :name
  
  def pretty_type
    self.go_type.singularize.capitalize
  end
end
