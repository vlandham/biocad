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
      dst = File.new([@basename, @format].compact.join("."), "w")
      lines = file.readlines[1...-1]
      lines.each do |line|
        dst << line.gsub(/^(\S+)\s+/, "")
      end
      dst
    end
    
  end
end