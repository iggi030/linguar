class Tandem < ActiveRecord::Base  
  attr_accessor :latlng
  
  belongs_to :user
  validates_presence_of :user_id, :motivation, :post_type, :lat, :lng, :learning_language
  
  
  def find_from_gmap_point(point, radious)
    
    self.find
  end
end
