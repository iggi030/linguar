class Tandem < ActiveRecord::Base  
  belongs_to :user
  validates_presence_of :user_id, :motivation, :post_type, :lat, :lng, :learning_language
  acts_as_mappable
  
  def self.per_page
    8
  end
  
  def find_from_gmap_point(point, radious)
    self.find
  end
  
  def offering_language_to_string
    Language.find_by_id(self.offering_language).name    
  end
  def learning_language_to_string
    Language.find_by_id(self.learning_language).name    
  end
  
  def post_type_to_string(type)
    types = ['language partner', 'pen pal' ]
    types[type]
  end
  
  def to_param
  description ="Searching for a #{self.offering_language_to_string} to
    #{self.learning_language_to_string} #{self.post_type_to_string(self.post_type-1)}".gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
  "#{self.id}-#{description.parameterize}"
  end  
end
