require 'test_helper'

class MicroarrayTest < ActiveSupport::TestCase
  def setup
    @microarray = Microarray.new(:cancer_datafile => File.new(File.join(File.dirname(__FILE__),"c_test.txt")),
                :normal_datafile => File.new(File.join(File.dirname(__FILE__),"n_test.txt")), 
                :name => "test 1")
  end
  
  def test_microarray_gets_output_file_name
    assert @microarray.save
    assert_not_equal @microarray.output_file_name, nil
  end
  
  
  
end
