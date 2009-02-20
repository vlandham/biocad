class GOTermsController < ApplicationController
  def show
    @go_term = GOTerm.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @interaction }
    end
  end
end