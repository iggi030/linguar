class Card < ActiveRecord::Base
  belongs_to  :glossary
  #has_one    :knowability
end
