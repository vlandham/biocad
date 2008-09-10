class InteractionsController < ApplicationController
  # GET /interactions
  # GET /interactions.xml
  def index
    @interactions = Interaction.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @interactions }
    end
  end

  # GET /interactions/1
  # GET /interactions/1.xml
  def show
    @interaction = Interaction.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interaction }
    end
  end

  # GET /interactions/new
  # GET /interactions/new.xml
  def new
    @interaction = Interaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @interaction }
    end
  end

  # GET /interactions/1/edit
  def edit
    @interaction = Interaction.find(params[:id])
  end

  # POST /interactions
  # POST /interactions.xml
  def create
    @interaction = Interaction.new(params[:interaction])

    respond_to do |format|
      if @interaction.save
        flash[:notice] = 'Interaction was successfully created.'
        format.html { redirect_to(@interaction) }
        format.xml  { render :xml => @interaction, :status => :created, :location => @interaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @interaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /interactions/1
  # PUT /interactions/1.xml
  def update
    @interaction = Interaction.find(params[:id])

    respond_to do |format|
      if @interaction.update_attributes(params[:interaction])
        flash[:notice] = 'Interaction was successfully updated.'
        format.html { redirect_to(@interaction) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @interaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /interactions/1
  # DELETE /interactions/1.xml
  def destroy
    @interaction = Interaction.find(params[:id])
    @interaction.destroy

    respond_to do |format|
      format.html { redirect_to(interactions_url) }
      format.xml  { head :ok }
    end
  end
end
