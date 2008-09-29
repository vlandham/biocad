class GeneType < ActiveRecord::Base
  belongs_to :gene
  belongs_to :cancer
end