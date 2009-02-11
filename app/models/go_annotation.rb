class GOAnnotation < ActiveRecord::Base
  belongs_to :go_term
  belongs_to :gene
  has_and_belongs_to_many :references
end
