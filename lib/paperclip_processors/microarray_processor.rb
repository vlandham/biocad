module Paperclip
  class MicroarrayProcessor < Processor
    def initialize(file, options = {})
      super
      # @file = file # in constructor of parent class
      # @types = options 
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end
    
    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))
      lines = file.readlines[1...-1]
      lines.each do |line|
        dst << line.gsub(/^(\S+)\s+/, "")
        # TODO: take $1 and stick them into a new file to store the gene names.  should have same base path as the temp file we're making.
      end
      dst
    end
    
  end
end