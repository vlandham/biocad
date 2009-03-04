class GeneGroupsController < ApplicationController
  # GET /gene_groups
  # GET /gene_groups.xml
  def index
    @gene_groups = GeneGroup.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @gene_groups }
    end
  end

  # GET /gene_groups/1
  # GET /gene_groups/1.xml
  def show
    @gene_group = GeneGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @gene_group }
      format.text { render :text => @gene_group.json_query.to_s}
    end
  end
  
  def visualize
    @gene_group = GeneGroup.find(params[:id])
  end

  # GET /gene_groups/new
  # GET /gene_groups/new.xml
  # def new
  #   @gene_group = GeneGroup.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @gene_group }
  #   end
  # end

  # GET /gene_groups/1/edit
  # def edit
  #   @gene_group = GeneGroup.find(params[:id])
  # end

  # POST /gene_groups
  # POST /gene_groups.xml
  def create
    @gene_group = GeneGroup.new(params[:gene_group])

    respond_to do |format|
      if @gene_group.save
        flash[:notice] = 'Gene Group was successfully created.'
        format.html { redirect_to(@gene_group) }
        format.xml  { render :xml => @gene_group, :status => :created, :location => @gene_group }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @gene_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /gene_groups/1
  # PUT /gene_groups/1.xml
  def update
    @gene_group = GeneGroup.find(params[:id])
    # TODO: There has got to be a better way to do this
    gene_ids = params.reject {|k,v| k !~ /^gene-/}.values
    genes = gene_ids.map {|g_id| Gene.find(g_id)}
    genes.each do |gene|
      @gene_group.genes << gene unless @gene_group.genes.include? gene
    end
    respond_to do |format|
      
      if @gene_group.save
        flash[:notice] = 'GeneGroup was successfully updated.'
        format.html { redirect_to(@gene_group) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @gene_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /gene_groups/1
  # DELETE /gene_groups/1.xml
  # def destroy
  #   @gene_group = GeneGroup.find(params[:id])
  #   @gene_group.destroy
  # 
  #   respond_to do |format|
  #     format.html { redirect_to(gene_groups_url) }
  #     format.xml  { head :ok }
  #   end
  # end
end
