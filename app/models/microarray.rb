class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_attached_file :datafile
end
