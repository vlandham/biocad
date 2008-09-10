class MicroarraysController < ApplicationController
  # GET /microarrays
  # GET /microarrays.xml
  def index
    @microarrays = Microarray.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @microarrays }
    end
  end

  # GET /microarrays/1
  # GET /microarrays/1.xml
  def show
    @microarray = Microarray.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @microarray }
    end
  end

  # GET /microarrays/new
  # GET /microarrays/new.xml
  def new
    @microarray = Microarray.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @microarray }
    end
  end

  # GET /microarrays/1/edit
  def edit
    @microarray = Microarray.find(params[:id])
  end

  # POST /microarrays
  # POST /microarrays.xml
  def create
    @microarray = Microarray.new(params[:microarray])

    respond_to do |format|
      if @microarray.save
        flash[:notice] = 'Microarray was successfully created.'
        format.html { redirect_to(@microarray) }
        format.xml  { render :xml => @microarray, :status => :created, :location => @microarray }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @microarray.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /microarrays/1
  # PUT /microarrays/1.xml
  def update
    @microarray = Microarray.find(params[:id])

    respond_to do |format|
      if @microarray.update_attributes(params[:microarray])
        flash[:notice] = 'Microarray was successfully updated.'
        format.html { redirect_to(@microarray) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @microarray.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /microarrays/1
  # DELETE /microarrays/1.xml
  def destroy
    @microarray = Microarray.find(params[:id])
    @microarray.destroy

    respond_to do |format|
      format.html { redirect_to(microarrays_url) }
      format.xml  { head :ok }
    end
  end
end
