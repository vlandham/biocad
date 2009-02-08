module Paperclip
  class MicroarrayProcessor < Processor
    def initialize(file, options = {})
      super
      # @file = file
      # @types = options 
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @name = options[:name]
      @file.rewind
      @lines = @file.readlines[1...-1]
    end
    
    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))   
      @lines.each do |line|
        new_line = line.gsub(/^(\S+)\s+/, "")
        if @name == :raw
          dst << new_line
        elsif @name == :genes
          dst << $1.gsub(/["]/, " ").strip << "\n"
        else
          logger.warn "[microarray processor] - ERROR: name: #{@name} unknown defaulting to raw"
          dst << new_line
        end #if
      end #each
      dst
    end #make    
  end #MicroarrayProcessor
end #Paperclip