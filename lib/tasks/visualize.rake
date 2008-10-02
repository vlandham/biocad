namespace :visualize do
  desc ""
  task :cancers => :environment do
    require 'rubigraph'
    include Rubigraph
    Rubigraph.init
    
    cancers = Cancer.find(:all)
    genes_vertices = Hash.new
    cancers.each do |cancer|
      v = Vertex.new
      v.label = cancer.name
      v.color = '#ffff40'
      cancer.genes.each do |gene|
        g = genes_vertices[gene.gene_symbol] || Vertex.new
        g.label = gene.gene_symbol
        Edge.new(v,g)
        genes_vertices[gene.gene_symbol] = g
      end
    end
  end

end