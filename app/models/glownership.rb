class Glownership < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :glossary
end
