class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_attached_file :normal_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension",
                    :styles => {:raw => {:name => "raw"}},
                    :processors => [:microarray_processor]
                    
  has_attached_file :cancer_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension",
                    :styles => {:raw => {:name => "raw"}},
                    :processors => [:microarray_processor]
  
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
    set_environmental_variables
    # puts self.normal_datafile.path
    larger_dataset_executable = "#{RAILS_ROOT}/lib/bin/kstoweb"
    smaller_dataset_executable = "#{RAILS_ROOT}/lib/bin/tstoweb"
    
    output_name = File.join(File.dirname(self.normal_datafile.path),"..","output", File.basename(self.normal_datafile.path))
    FileUtils.mkdir_p(output_name)
    
    `#{smaller_dataset_executable} #{self.normal_datafile.path} #{self.cancer_datafile.path} #{output_name}`
  end
    
  def set_environmental_variables
    # TODO: make sure this works with more OS's than just mac
    ENV['DYLD_LIBRARY_PATH'] = "/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries"    
    ENV['XAPPLRESDIR'] = "/Applications/MATLAB_R2008a/X11/app-defaults"
    # `export DYLD_LIBRARY_PATH=/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries`
    # `export XAPPLRESDIR=/Applications/MATLAB_R2008a/X11/app-defaults`
  end
  
  
end
