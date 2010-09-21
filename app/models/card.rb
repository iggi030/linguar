class Card < ActiveRecord::Base
  belongs_to  :glossary
  has_many    :knowabilities
  has_many    :users,   :through => :knowabilities
  
  def self.per_page
    25
  end
end
