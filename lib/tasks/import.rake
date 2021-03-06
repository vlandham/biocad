def get_data_path(filename)
  File.expand_path(File.join(RAILS_ROOT, 'data', filename))   
end

def default_options
  {:col_sep => '|', :row_sep => :auto, :headers => true}
end

def find_go_terms(go_section,term_type)
  terms = []
  raw_terms = go_section.split(";").each {|x| x.strip!}.delete_if {|x| x.strip == "-"}
  unless raw_terms.empty?
    # there is at least one go term to be parsed
    raw_terms.each do |raw_term|
      # puts "parsing #{raw_term}"
      term_name = raw_term.gsub(/\(GO:(\d+)\)/, "").strip
      term_number = $1.to_i
      go_term = GOTerm.find_by_number(term_number)
      go_term ||= GOTerm.new(:number => term_number, :go_type => term_type, :name => term_name).save!
      terms << go_term
    end #each term
  end #unless 
  terms
end #find_go_terms

def parse_references(reference_section)
  raw_references = reference_section.split(";").each {|x| x.strip!}.delete_if {|x| x.strip == "-"}
  references = []
  raw_references.each do |raw_reference|
    reference = Reference.find_or_create_by_number(raw_reference.to_i)
    references << reference
  end
  references
end

namespace :import do
  
  task :all => ['db:reset',:cancers, :gene_info, :ppi, :tf, :go]
  
  desc "import the oncogene - cancer data.  This is probably the first one to import"
  task :cancers => :environment do
    require 'faster_csv'
    types = {'onco' => 'oncogene_cancer.txt', 'suppressor' => 'suppressor_cancer.txt'}
    # gene_cancer_file = 'oncogene_cancer.txt'
    # 
    types.each do |type,gene_cancer_file|
      full_file_path = get_data_path(gene_cancer_file)
      puts "Reading in: #{full_file_path}"
      options = default_options
    
      i = 0
      FasterCSV.foreach(full_file_path,options) do |row|
        gene = Gene.find_or_create_by_gene_symbol(row['gene'])
        cancers = row['cancer']
        if cancers
          cancers = cancers.split(";").compact 
          cancers.each do |cancer_name|
            cancer = Cancer.find_or_create_by_name(cancer_name.strip)
            unless gene.cancers.include?(cancer)
              cancer.save!
              gene.gene_types.create(:association => type, :cancer_id => cancer.id)
            end
          end
        else
          gene.gene_types.create(:association => type)
        end #if
      
        gene.save!
        i += 1
      end
      puts "Imported #{i} genes"
    end
  end
  
    desc "import go terms for genes in the database"
    task :go => :environment do
      require 'faster_csv'
      go_file = 'hprd_gene_go.txt'
      full_go_file = get_data_path(go_file)
      options = default_options
      
      puts "looking at#{full_go_file}"
      FasterCSV.foreach(full_go_file, options) do |row|
        # find gene
        gene = Gene.find_by_gene_symbol(row['gene_symbol'])
        if(gene)
          ["functions", "processes", "components"].each do |type|
            terms = find_go_terms(row[type], type)
            terms.each do |go_term|
              # create new annotation
              annotation = GOAnnotation.find_or_create_by_gene_id_and_go_term_id(:gene_id => gene.id, :go_term_id => go_term.id)
              # create new references
              references = parse_references(row["#{type}_reference"])
              annotation.references = references
              annotation.save!
            end
          end
        end #if gene
      end
    end
  
  desc "import transcription factors"
  task :tf => :environment do
    require 'faster_csv'
    ppi_file = 'human_TF.txt'
    full_ppi_file = get_data_path(ppi_file)
    options = default_options
    i = 0
    puts "looking at #{full_ppi_file}"
    FasterCSV.foreach(full_ppi_file, options) do |row|
      # puts "adding #{row.inspect}"
      # Find the gene objects with the gene_symbols found in the particular row
      gene1 = Gene.find_by_gene_symbol(row['gene1'])
      gene2 = Gene.find_by_gene_symbol(row['gene2'])
      if(gene1 && gene2)
        tf = TranscriptionFactor.new(:gene_id => gene1.id, :gene_id_target => gene2.id)
        tf.save!
        i += 1
        puts "on number #{i}" if i % 300 == 0
      end
    end
     puts "imported #{TranscriptionFactor.count} Transcription Factors" 
  end
  
  desc "import PPI interaction data (hprd) from Mei"
  task :ppi => :environment do
    # Bring in the faster csv library
    require 'faster_csv'
    # Setup file name which will be in /data/test_ppi.txt
    ppi_file = 'hprd_ppi.txt'
    full_ppi_file = get_data_path(ppi_file)
    # Setup options to use to parse csv
    # So its not really comma separated, its | separated - hence the :col_sep
    # Also, i added headers so i can access the values for each column as a hash (aka map)
    options = default_options
    i = 0
    # Clear out the interaction table so we can refill it
    Interaction.delete_all
    
    # Loop through each line of the file - FasterCSV will break it up how we want it
    puts "looking at #{full_ppi_file}"
    FasterCSV.foreach(full_ppi_file, options) do |row|
      # puts "adding #{row.inspect}"
      # Find the gene objects with the gene_symbols found in the particular row
      gene1 = Gene.find_by_gene_symbol(row['gene1'])
      gene2 = Gene.find_by_gene_symbol(row['gene2'])
      if(gene1 && gene2)
      
        # Save them so that they have a spot in the database (if they weren't there already)
        # gene1.save!
        # gene2.save!
      
        # create a new interaction between these two genes, and with the rest of the information in the row
        interaction = Interaction.new(:gene_id => gene1.id, :gene_id_target => gene2.id,
                                      :source => row['reference'], :experiment_type => row['experiment_type'])
        # save all three -- the ! indicates that it will throw an error if there is a problem
        interaction.save!
        i += 1
        puts "on number #{i}" if i % 500 == 0
      end
    end
    puts "imported #{Interaction.count} ppi interactions" 
    puts "Currently #{Gene.count} genes"   
  end
  
  desc "import gene information from hprd mapping"
  task :gene_info => :environment do
    require 'faster_csv'
    mapping_file = 'hprd_mappings.txt'
    full_mapping_file = get_data_path(mapping_file)
    options = default_options
    
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
    new_proteins = Array.new
    
    current_genes = Gene.find(:all)
    current_genes.each do |gene|
      csv_row = gene_symbol_hash[gene.gene_symbol]
      if csv_row
        row_hash = {:swissprot => csv_row['swissprot'], :entrez => csv_row['entrez'], 
                    :omim => csv_row['omim'], :name => csv_row['name']}
        # remove those '-'
        row_hash.delete_if {|key,value| value == "-"}
        update_gene_hash[gene.id] = row_hash
        
        if csv_row['synonyms'] 
          # get the current names contained in the synonyms for this gene
          current_synonyms = gene.synonyms.map {|gs| gs.synonym}
          syns = csv_row['synonyms'].split(';')
          syns.delete("-")
          syns.each do |syn|
            syn.strip!
            # only bring them in if its not in the database yet.
            unless current_synonyms.include? syn
              synonyms << {:synonym => syn, :gene_id => gene.id} 
            end
          end
        end #synonyms
        
        if csv_row['proteins']
          current_proteins = gene.proteins.map {|gp| gp.name}
          proteins = csv_row['proteins'].split(';')
          proteins.delete("-")
          proteins.each do |protein|
            protein.strip!
            unless current_proteins.include? protein
              new_proteins << {:name => protein, :gene_id => gene.id} 
            end
          end
        end #proteins
        
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
    
    puts "adding new proteins"
    Protein.create(new_proteins)
    puts "- done"
    puts "#{new_proteins.size} proteins created"
  end
  
end