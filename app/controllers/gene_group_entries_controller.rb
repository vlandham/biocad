class GeneGroupEntriesController < ApplicationController
  before_filter :find_gene_group
  
  # DELETE /gene_group_entries/1
  # DELETE /gene_group_entries/1.xml
  def destroy
    # Warning: we're finding by gene id, not gene_group id -- not sure this is a good idea
    @gene_group_entry = @gene_group.gene_group_entries.find_by_gene_id(params[:id])
    @gene_group_entry.destroy

    respond_to do |format|
      format.html { redirect_to(gene_group_url(@gene_group)) }
      format.xml  { head :ok }
    end
  end
  
  
  private
  
  def find_gene_group
    @gene_group = GeneGroup.find(params[:gene_group_id])
  end
end