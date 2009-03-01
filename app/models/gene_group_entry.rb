class GeneGroupEntry < ActiveRecord::Base
  belongs_to :gene_group
  belongs_to :gene
end
