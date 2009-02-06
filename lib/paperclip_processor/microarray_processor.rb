module Paperclip
  class MicroarrayProcessor < Processor
    def initialize(file, options = {})
      super
      @file = file
      @types = options
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
    end
    
    def make
      
    end
  end
end