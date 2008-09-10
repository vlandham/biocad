class Experiment < ActiveRecord::Base
  belongs_to :cancer
  has_many :microarrays
end
