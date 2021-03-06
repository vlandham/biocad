def set_environmental_variables
  # TODO: make sure this works with more OS's than just mac
  ENV['DYLD_LIBRARY_PATH'] = "/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries"    
  ENV['XAPPLRESDIR'] = "/Applications/MATLAB_R2008a/X11/app-defaults"
  # `export DYLD_LIBRARY_PATH=/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries`
  # `export XAPPLRESDIR=/Applications/MATLAB_R2008a/X11/app-defaults`
end

def large_dataset?(microarray)
  # read the first line of the datafile to get the number of conditions
  size = File.open(microarray.normal_datafile.path, "r") {|f| f.readline.split(/\s+/).length}
  size = size -1 #for the name column
  puts "[rake - microarray] number of conditions: #{size}"
  large = size > 30 ? true : false
  large
end

def process_results(microarray)
  puts "[rake - microarray] Processing results"
  results = File.open(microarray.output_file_name, "r") {|f| f.readlines}
  gene_names = File.open(microarray.normal_datafile.path(:genes)) {|f| f.readlines}
  results.map! do |line|
    values = line.split("\t")
    name_index = values[0].strip.to_i
    name = gene_names[name_index]
    p_value = values[1].strip.to_f
    
    user_gene = {:name => name, :p_value => p_value, :microarray_id => microarray.id}
    # attempt to match up an actual gene to this user gene
    gene = Gene.find_by_gene_symbol(user_gene[:name].to_s.strip.upcase)
    user_gene[:gene_id] = gene.id if gene
    user_gene
  end
  UserGene.create results
end

# grabs all the genes associated with this microarray
#  if any and creates a gene group with them
def create_gene_group(microarray)
  puts "[rake - microarray] Creating Gene Group"
  group = nil
  genes_for_group = microarray.genes
  unless(genes_for_group.empty?)
    puts "[rake - microarray] Genes found for gene group: num: #{genes_for_group.size}"
    group = GeneGroup.new
    genes_for_group.each do |gene|
      group.genes << gene
    end
    group.save!
  else
    puts "[rake - microarray] Genes not found for gene group"
  end
  group
end

desc "run microarray analysis tools"
task :analyze_microarray => :environment do
  set_environmental_variables
  microarray = Microarray.find(ENV["MICROARRAY_ID"])
  if(!microarray)
    puts "[rake - microarray] ERROR- microarray not found"
  else
    puts "[rake - microarray] Using microarray ID: #{microarray.id}"
  end

  larger_dataset_executable = "#{RAILS_ROOT}/lib/bin/kstoweb"
  smaller_dataset_executable = "#{RAILS_ROOT}/lib/bin/tstoweb"
  
  executable = large_dataset?(microarray) ? larger_dataset_executable : smaller_dataset_executable
  args = [microarray.normal_datafile.path(:raw), microarray.cancer_datafile.path(:raw), microarray.output_file_name]
  
  puts "[rake - microarray] Running command: #{executable} #{args.join(", ")}"
  system executable, *args
  puts "[rake - microarray] Return code: #{$?}"
  if($? == 0)
    process_results(microarray)
    gene_group = create_gene_group(microarray)
    if gene_group
      microarray.gene_group = gene_group
      microarray.save!
    end
  end
  microarray.update_attributes({:return_value => $?, :completed_at => Time.now})
end