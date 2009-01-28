class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_attached_file :normal_datafile
  has_attached_file :cancer_datafile
  
  validates_attachment_presence :normal_datafile
  validates_attachment_presence :cancer_datafile
end
