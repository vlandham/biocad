class GeneGroup < ActiveRecord::Base
  has_many :gene_group_entries
  has_many :genes, :through => :gene_group_entry
end
