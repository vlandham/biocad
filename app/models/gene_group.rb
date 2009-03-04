class GeneGroup < ActiveRecord::Base
  has_many :gene_group_entries
  has_many :genes, :through => :gene_group_entries, :order => "gene_symbol"
  
  def to_s
    self.name
  end
  
  def json_query
    gene_options = [:gene_symbol, :id]
    self.to_json(:only => [:name,:id], :include => 
      {:genes => {:only => [:gene_symbol, :id], :include => 
        {
          :gene_interactions_in => {:only => gene_options},
          :gene_interactions_out => {:only => gene_options},
          :gene_transcription_factors_in => {:only => gene_options}
        }
      }}
    )
  end
  
end
