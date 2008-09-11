namespace :import do
  
  desc "import PPI interaction data from Mei"
  task :ppi => :environment do
    require 'faster_csv'
    ppi_file = 'test_ppi.txt'
    full_ppi_file = File.expand_path(File.join(RAILS_ROOT, 'data', ppi_file))
    options = {:col_sep => '|', :row_sep => :auto, :headers => true}
    i = 0
    FasterCSV.foreach(full_ppi_file, options) do |row|
      gene1 = Gene.find_or_create_by_gene_symbol(row['gene1'])
      gene2 = Gene.find_or_create_by_gene_symbol(row['gene2'])
      
      interaction = Interaction.new(:source => row['reference'], :experiment_type => row['experiment_type'])
      gene1.interactions << interaction
      gene2.interactions << interaction
      gene1.save!
      gene2.save!
      interaction.save!
      i += 1
      puts "on number #{i}" if i % 500 == 0
    end
    
    
  end
  
end