class GenesController < ApplicationController
  # GET /genes
  # GET /genes.xml
  def index
    @genes = Gene.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @genes }
      format.text { render :text => @genes.to_json(:only => [:gene_symbol], :include => {:cancers => {:only => [:name]}} ).to_s}
    end
  end
  
  # GET /genes/1
  # GET /genes/1.xml
  def show
    @gene = Gene.find(params[:id])
    # @interactions = @gene.interactions
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gene }
      format.text { render :text => @gene.to_json(:only => [:gene_symbol], :include => {:cancers => {:only => [:name]}} ).to_s}
    end
  end

  # GET /genes/new
  # GET /genes/new.xml
  def new
    @gene = Gene.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @gene }
    end
  end

  # GET /genes/1/edit
  def edit
    @gene = Gene.find(params[:id])
  end

  # POST /genes
  # POST /genes.xml
  def create
    @gene = Gene.new(params[:gene])

    respond_to do |format|
      if @gene.save
        flash[:notice] = 'Gene was successfully created.'
        format.html { redirect_to(@gene) }
        format.xml  { render :xml => @gene, :status => :created, :location => @gene }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gene.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /genes/1
  # PUT /genes/1.xml
  def update
    @gene = Gene.find(params[:id])

    respond_to do |format|
      if @gene.update_attributes(params[:gene])
        flash[:notice] = 'Gene was successfully updated.'
        format.html { redirect_to(@gene) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gene.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /genes/1
  # DELETE /genes/1.xml
  def destroy
    @gene = Gene.find(params[:id])
    @gene.destroy

    respond_to do |format|
      format.html { redirect_to(genes_url) }
      format.xml  { head :ok }
    end
  end
end
