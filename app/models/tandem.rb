class Tandem < ActiveRecord::Base  
  belongs_to :user
  validates_presence_of :user_id, :motivation, :post_type, :location, :learning_language
  before_save :geocode_location
  
  def self.search(search, args = {})
    self.build_search_hash search, args
    self.paginate(:all, @search_hash)
  end
  
  def self.search_by_filters(params, page)
    location = Geokit::Geocoders::YahooGeocoder.geocode(params[:location])
    
    paginate(:all, :conditions => 
      ['post_type = ? AND offering_language = ? AND lat BETWEEN ? AND ? AND lng BETWEEN ? AND ?', 
        '1', 
        params[:language],
        (location.lat.to_f - 200.0),
        (location.lat.to_f + 200.0),
        (location.lng.to_f - 200.0),
        (location.lng.to_f + 200.0)
      ], :page => page, :order => 'created_at DESC')
  end
  
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
  
  private
  
  def geocode_location
    latlong = Geokit::Geocoders::YahooGeocoder.geocode(self.location)
    self.lat = latlong.lat
    self.lng = latlong.lng
  end
  
  def self.build_search_hash(search, args = {})
    @search_hash = {:conditions => search.conditions,
                    :page => args[:page],
                    :order => 'created_at DESC'}
  end
end
