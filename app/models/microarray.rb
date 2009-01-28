class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_attached_file :normal_datafile
  has_attached_file :cancer_datafile
  
end
