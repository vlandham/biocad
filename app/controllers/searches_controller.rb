class SearchesController < ApplicationController
  def index
    @cancers = Cancer.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genes }
    end
  end
end