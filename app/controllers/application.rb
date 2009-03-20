class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem
  
  helper :all # include all helpers, all the time
  protect_from_forgery :secret => 'b0a876313f3f9195e9bd01473bc5cd06'
  filter_parameter_logging :password, :password_confirmation
  
  before_filter :find_gene_group
  
  private
  
  def find_gene_group
    id =  session[:gene_group_id]
    @static_gene_group = nil
    if id && GeneGroup.exists?(id)
      @static_gene_group = GeneGroup.find(id, :include => :genes)
    else
      @static_gene_group = GeneGroup.create(:name => "Your Gene Group")
    end
    session[:gene_group_id] = @static_gene_group.id
    @static_gene_group
  end


end
