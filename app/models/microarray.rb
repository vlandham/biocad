class Microarray < ActiveRecord::Base
  belongs_to :experiment
  has_many :user_genes, :dependent => :destroy
  has_many :genes, :through => :user_genes
  belongs_to :gene_group
  
  has_attached_file :normal_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension",
                    :styles => {:raw => {:name => :raw}, :genes => {:name => :genes}},
                    :processors => [:microarray_processor]
                    
  has_attached_file :cancer_datafile, :path => ":rails_root/public/:class/:id/:attachment/:style_:basename.:extension",
                    :url => "/:class/:id/:attachment/:style_:basename.:extension",
                    :styles => {:raw => {:name => :raw}, :genes => {:name => :genes}},
                    :processors => [:microarray_processor]
    
  validates_attachment_presence :normal_datafile
  validates_attachment_content_type :normal_datafile, :content_type => 'text/plain'
  validates_attachment_presence :cancer_datafile
  validates_attachment_content_type :cancer_datafile, :content_type => 'text/plain'
  
  def working?
    self.completed_at == nil
  end
    
  def start_analysis
    call_rake :analyze_microarray, :microarray_id => self.id
  end  
  
  
  def set_output_file_name
    name = File.expand_path(File.join(File.dirname(self.normal_datafile.path),"..","output", "results.txt"))
    FileUtils.mkdir_p(File.dirname(name))
    system "touch #{name}"
    self.update_attribute(:output_file_name, name)
  end
  
  private
  
  def call_rake(task, options = {})
    options[:rails_env] = Rails.env
    args = options.map {|n,v| "#{n.to_s.upcase}='#{v}'"}
    system "rake #{task} #{args.join(' ')} --trace >> #{Rails.root}/log/rake.log &"
  end
  
end
