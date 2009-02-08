class UserGene < ActiveRecord::Base
  belongs_to :gene
  belongs_to :microarray
end
