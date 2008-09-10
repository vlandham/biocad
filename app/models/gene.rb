class Gene < ActiveRecord::Base
  has_and_belongs_to_many :cancers
  has_and_belongs_to_many :interactions
  has_and_belongs_to_many :pathways
  has_many :synonyms
end
