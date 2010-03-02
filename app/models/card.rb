class Card < ActiveRecord::Base
  belongs_to  :glossary
  has_many    :knowabilities
  has_many    :users,   :through => :knowabilities
end
