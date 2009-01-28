class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_attached_file :normal_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension"
  has_attached_file :cancer_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension"
  
  validates_presence_of :name
  validates_presence_of :output_file_name
  
  validates_attachment_presence :normal_datafile
  validates_attachment_content_type :normal_datafile, :content_type => 'text/plain'
  validates_attachment_presence :cancer_datafile
  validates_attachment_content_type :cancer_datafile, :content_type => 'text/plain'
  
  
  before_validation_on_create :set_output_file_name
  after_save :start_microarray_analysis
  
  private
  
  def set_output_file_name
    self.output_file_name = self.name.downcase.gsub(/\s/, "_").concat("output.txt")
  end
  
  def start_microarray_analysis
    split_up_datasets
  end
  
  def split_up_datasets
    [self.normal_datafile, self.cancer_datafile].each do |datafile|
      puts datafile.url
    end
  end
  
end
