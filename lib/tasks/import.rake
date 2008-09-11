namespace :import do
  
  task :all => [:ppi, :gene_info]
  
  desc "import PPI interaction data (hprd) from Mei"
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
    puts "looking at #{full_ppi_file}"
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
    puts "Currently #{Gene.count} genes"   
  end
  
  desc "import gene information from hprd mapping"
  task :gene_info => :environment do
    require 'faster_csv'
    mapping_file = 'hprd_mappings.txt'
    full_mapping_file = File.expand_path(File.join(RAILS_ROOT, 'data', mapping_file))
    options = {:col_sep => '|', :row_sep => :auto, :headers => true}
    
    puts "reading in #{full_mapping_file}"
    raw_table = FasterCSV.read(full_mapping_file, options)
    
    puts "mapping to gene symbol"
    gene_symbol_hash = Hash.new
    raw_table.each do |row|
      gene_symbol_hash[row["gene_symbol"]] = row
    end
    puts "- done mapping"
    puts "finding new information on current genes"
    update_gene_hash = Hash.new
    synonyms = Array.new
    current_genes = Gene.find(:all)
    current_genes.each do |gene|
      csv_row = gene_symbol_hash[gene.gene_symbol]
      if csv_row
        row_hash = {:swissprot => csv_row['swissprot'], :entrez => csv_row['entrez'], 
                    :omim => csv_row['omim'], :name => csv_row['name']}
        # remove those '-'
        row_hash.delete_if {|key,value| value == "-"}
        update_gene_hash[gene.id] = row_hash
        # TODO: make this smarter about importing synonyms
        if csv_row['synonyms'] && gene.synonyms.empty?
          syns = csv_row['synonyms'].split(',')
          syns.delete("-")
          syns.each do |syn|
            syn.strip!
            synonyms << {:synonym => syn, :gene_id => gene.id}
          end
        end
      end
    end
    puts "- done"
    
    puts "updating genes"
    Gene.update(update_gene_hash.keys, update_gene_hash.values)
    puts "- done"
    puts "#{update_gene_hash.size} genes updated"
    
    puts "adding new synonyms"
    Synonym.create(synonyms)
    puts "- done"
    puts "#{synonyms.size} synonyms created"
  end
  
end