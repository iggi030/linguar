class Search
  attr_reader :options

  def initialize(model, options)
    @model = model
    @options = options || {}
  end
  
  def tandem
    options[:tandem_partner]
  end

  def penpal
    options[:pen_pal]
  end
  
  def language
    options[:language]
  end
  
  def location
    options[:location]
  end
  
  def with_tandems?
    tandem.present?
  end

  def with_penpals?
    penpal.present?
  end
  
  def with_language?
    language.present?
  end
  
  def with_location?
    location.present?
  end

  def conditions
    conditions = []
    and_conditions = []
    parameters = []
    
    return nil if options.empty?
    
    if with_tandems?
      conditions << "#{@model.table_name}.post_type = ?"
      parameters << "#{1}"
    end
    
    if with_penpals?
      conditions << "#{@model.table_name}.post_type = ?"
      parameters << "#{2}"
    end
      
    if with_language?
      and_conditions << "#{@model.table_name}.offering_language = ?"
      parameters << "#{language}"
    end
    
    if with_location?
      coords = get_coordinates
      and_conditions << "#{@model.table_name}.lat BETWEEN ? AND ? "
       and_conditions << "#{@model.table_name}.lng BETWEEN ? AND ? "
      parameters << "#{coords.lat - 5.0}"
      parameters << "#{coords.lat + 5.0}"
      parameters << "#{coords.lng - 5.0}"
      parameters << "#{coords.lng + 5.0}"
    end
    
    unless conditions.empty?
      all_conditions = "("
      all_conditions << conditions.join(" OR ")
      all_conditions << ") AND "
      all_conditions << and_conditions.join(" AND ")
      [all_conditions , *parameters]       
    else
      nil
    end
  end
  
  private
  
  def get_coordinates
    Geokit::Geocoders::YahooGeocoder.geocode(options[:location])
  end
end