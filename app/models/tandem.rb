class Tandem < ActiveRecord::Base  
  attr_accessor :latlng
  
  belongs_to :user
  validates_presence_of :user_id, :motivation, :post_type, :lat, :lng, :learning_language
  
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
end
