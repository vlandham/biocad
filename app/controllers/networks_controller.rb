class NetworksController < ApplicationController
  def index
    # TODO: ugly fix for getting the gene ids, there should be a better way
    @par  = []
    params.keys.each do |key|
      @par << key.to_i if key.to_i != 0
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genes }
    end
  end
end