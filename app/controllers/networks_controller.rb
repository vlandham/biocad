class NetworksController < ApplicationController
  def index
    # TODO: ugly fix for getting the gene ids, there should be a better way
    par  = []
    params.keys.each do |key|
      par << key.to_i if key.to_i != 0
    end
    # @par = params
    # @genes = Gene.find(par)
    @genes = par
    gene_options = [:gene_symbol, :id]
    respond_to do |format|
      # format.text { render :json => @genes.to_json({:only => gene_options, :include => 
      #   {
      #     :gene_interactions_in => {:only => gene_options},
      #     :gene_interactions_out => {:only => gene_options},
      #     :gene_transcription_factors_in => {:only => gene_options}
      #   }
      #   })}
      format.html # index.html.erb
      format.xml  { render :xml => @genes }
     
    end
  end
end