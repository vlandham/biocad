class SearchesController < ApplicationController
  def index
    @search = Search.new
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genes }
    end
  end
  
  def show
   @search = Search.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @search }
    end
  end
  
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to(@search) }
        format.xml  { render :xml => @search, :status => :created, :location => @search }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end
end