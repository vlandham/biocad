namespace :import do
  
  desc "import PPI interaction data from Mei"
  task :ppi => :environment do
    # Bring in the faster csv library
    require 'faster_csv'
    # Setup file name which will be in /data/test_ppi.txt
    ppi_file = 'test_ppi.txt'
    full_ppi_file = File.expand_path(File.join(RAILS_ROOT, 'data', ppi_file))   
    # Setup options to use to parse csv
    # So its not really comma separated, its | separated - hence the :col_sep
    # Also, i added headers so i can access the values for each column as a hash (aka map)
    options = {:col_sep => '|', :row_sep => :auto, :headers => true}
    i = 0
    # Clear out the interaction table so we can refill it
    Interaction.delete_all
    
    # Loop through each line of the file - FasterCSV will break it up how we want it
    FasterCSV.foreach(full_ppi_file, options) do |row|
      # puts "adding #{row.inspect}"
      # Find or create the gene objects with the gene_symbols found in the particular row
      gene1 = Gene.find_or_create_by_gene_symbol(row['gene1'])
      gene2 = Gene.find_or_create_by_gene_symbol(row['gene2'])
      
      # Save them so that they have a spot in the database (if they weren't there already)
      gene1.save!
      gene2.save!
      
      # create a new interaction between these two genes, and with the rest of the information in the row
      interaction = Interaction.new(:gene_id => gene1.id, :gene_id_target => gene2.id, :source => row['reference'], :experiment_type => row['experiment_type'])
      # save all three -- the ! indicates that it will throw an error if there is a problem
      interaction.save!
      i += 1
      puts "on number #{i}" if i % 500 == 0
    end
    puts "imported #{Interaction.count} ppi interactions"
    
  end
  
end