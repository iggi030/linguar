class Glossary < ActiveRecord::Base
  has_many    :cards
  belongs_to  :user

  def find_from_language
    Language.find(self.from_language).name
  end
  
  def find_to_language
    Language.find(self.to_language).name
  end
end
