class CancersController < ApplicationController
  # GET /cancers
  # GET /cancers.xml
  def index
    @cancers = Cancer.search(params[:search], params[:find])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cancers }
    end
  end

  # GET /cancers/1
  # GET /cancers/1.xml
  def show
    @cancer = Cancer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cancer }
    end
  end

  # GET /cancers/new
  # GET /cancers/new.xml
  def new
    @cancer = Cancer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cancer }
    end
  end

  # GET /cancers/1/edit
  def edit
    @cancer = Cancer.find(params[:id])
  end

  # POST /cancers
  # POST /cancers.xml
  def create
    @cancer = Cancer.new(params[:cancer])

    respond_to do |format|
      if @cancer.save
        flash[:notice] = 'Cancer was successfully created.'
        format.html { redirect_to(@cancer) }
        format.xml  { render :xml => @cancer, :status => :created, :location => @cancer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cancer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cancers/1
  # PUT /cancers/1.xml
  def update
    @cancer = Cancer.find(params[:id])

    respond_to do |format|
      if @cancer.update_attributes(params[:cancer])
        flash[:notice] = 'Cancer was successfully updated.'
        format.html { redirect_to(@cancer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cancer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cancers/1
  # DELETE /cancers/1.xml
  def destroy
    @cancer = Cancer.find(params[:id])
    @cancer.destroy

    respond_to do |format|
      format.html { redirect_to(cancers_url) }
      format.xml  { head :ok }
    end
  end
end
