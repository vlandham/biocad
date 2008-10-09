class Search < ActiveRecord::Base
  def genes(page)
    @genes ||= find_genes(page)
  end
  
  def find_genes(page)
    scope = Gene.scoped({})
    scope = scope.scoped :conditions => ["genes.gene_symbol LIKE ?", "%#{gene_symbol}%"] unless gene_symbol.blank?
    scope = scope.scoped :conditions => ["genes.swissprot LIKE ?", "%#{swissprot}%"] unless swissprot.blank?
    scope = scope.scoped :conditions => ["genes.entrez LIKE ?", "%#{entrez}%"] unless entrez.blank?
    scope = scope.scoped :include => :cancers, :conditions => ["cancers.name LIKE ?", "%#{cancer_name}%"] unless cancer_name.blank?
    scope = scope.scoped :include => :synonyms, :conditions => ["synonyms.synonym LIKE ?", "%#{synonym}%"] unless synonym.blank?
    scope.paginate(:all, :page => page, :order => 'gene_symbol', :include => :synonyms)
  end
  
end