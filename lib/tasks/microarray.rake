def set_environmental_variables
  # TODO: make sure this works with more OS's than just mac
  ENV['DYLD_LIBRARY_PATH'] = "/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries"    
  ENV['XAPPLRESDIR'] = "/Applications/MATLAB_R2008a/X11/app-defaults"
  # `export DYLD_LIBRARY_PATH=/Applications/MATLAB_R2008a/bin/maci:/Applications/MATLAB_R2008a/sys/os/maci:/System/Library/Frameworks/JavaVM.framework/JavaVM:/System/Library/Frameworks/JavaVM.framework/Libraries`
  # `export XAPPLRESDIR=/Applications/MATLAB_R2008a/X11/app-defaults`
end


desc "run microarray analysis tools"
task :analyze_microarray => :environment do
  set_environmental_variables
  microarray = Microarray.find(ENV["MICROARRAY_ID"])

  larger_dataset_executable = "#{RAILS_ROOT}/lib/bin/kstoweb"
  smaller_dataset_executable = "#{RAILS_ROOT}/lib/bin/tstoweb"

  puts "[rake - microarray] Running command: #{smaller_dataset_executable} #{microarray.normal_datafile.path} #{microarray.cancer_datafile.path} #{microarray.output_file_name}"
  
  
  `#{smaller_dataset_executable} #{microarray.normal_datafile.path} #{microarray.cancer_datafile.path} #{microarray.output_file_name}`
end