class Synonym < ActiveRecord::Base
  belongs_to :gene
  def to_s
    self.synonym
  end
end
