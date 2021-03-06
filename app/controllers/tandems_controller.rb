class TandemsController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login, :only => [:new]
  
  def index
    page = params[:page] || 1
    @tandem_checked = true
    @pen_pal_checked = true
    
    if params[:filters] != nil
      @selected_town = params[:filters][:location] 
      @tandem_checked = !params[:filters][:tandem_partner].nil? 
      @pen_pal_checked = !params[:filters][:pen_pal].nil? 
      @language = params[:filters][:language].to_i
    end
    
    if params[:filters]
      @search = Search.new(Tandem, params[:filters])
      logger.debug "#{@search}"
      @tandems = Tandem.search(@search, :page => params[:page])
    else
      @tandems = Tandem.paginate(:all, :page => page, :order => 'created_at DESC')
    end
  end
  
  def show
    @tandem = Tandem.find(params[:id])
  end
  
  def new
    @tandem = Tandem.new
    @types = {'Tandem partner' => 1, 'Pen / Skype pal' => 2}
    
    request_ip = request.remote_ip
      if request_ip == "127.0.0.1"
        request_ip = "92.225.25.142"
      end
    user_location =  Geokit::Geocoders::IpGeocoder.geocode(request_ip) ||
    @visitors_town = user_location.city
    logger.debug "location: #{user_location}"
    @map = GMap.new("map_div")
    @map.control_init(:large_map => false,:map_type => true) 
    @map.set_map_type_init(GMapType::G_HYBRID_MAP)
    @map.center_zoom_init([user_location.lat,user_location.lng],4)
    @map.overlay_init(GMarker.new([user_location.lat,user_location.lng],
                                  :title => "Title",
                                  :info_window => "This description<br/> can have <b>HTML</b> in it!"))
  end
  
  def edit
     @tandem = current_user.tandems.find(params[:id])
     @types = {'Tandem partner' => 1, 'Pen / Skype pal' => 2}
    logger.debug "#{@tandem.post_type}"
     @map = GMap.new("map_div")
     @map.control_init(:large_map => false,:map_type => true) 
     @map.set_map_type_init(GMapType::G_HYBRID_MAP)
     @map.center_zoom_init([@tandem.lat, @tandem.lng],4)
     @map.overlay_init(GMarker.new([@tandem.lat, @tandem.lng],
                                   :title => "Title",
                                   :info_window => "This description<br/> can have <b>HTML</b> in it!"))
  end
  
  def update
    @tandem = current_user.tandems.find(params[:id])
    @tandem.update_attributes(params[:tandem])
    current_user.bio = @tandem.bio unless @tandem.bio == nil
    current_user.hobbies = @tandem.hobbies unless @tandem.hobbies == nil
    current_user.profession = @tandem.profession unless @tandem.profession == nil
    
    current_user.save
    if @tandem.save
      redirect_to @tandem
    else
      render :action => "edit"
    end
  end
  
  def update_map
	  @map = Variable.new("map")
	  location = Geokit::Geocoders::YahooGeocoder.geocode(params[:address])
	  @center = GLatLng.new([ location.lat, location.lng ])
	  logger.debug "location: #{@location}"
	  @marker = GMarker.new([location.lat,location.lng],:title => "Update", :info_window => "I have been placed through RJS")
  end
  
  def create
    @tandem = current_user.tandems.new(params[:tandem])
    if @tandem.save
      redirect_to(@tandem)
    else
      @types = {'Tandem partner' => 1, 'Pen / Skype pal' => 2}
      render :action => "new"
    end    
  end
  
  def destroy
    @post = current_user.tandems.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.xml  { head :ok }
    end
  end
    
  def search
    @types = {'Tandem partner' => 1, 'Pen / Skype pal' => 2}
  end  
end
