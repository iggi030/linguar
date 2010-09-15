class TandemsController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  
  def index
    if params[:tandem]
      @tandems = Tandem.find(:all, :conditions => 
      ['post_type = ? AND offering_language = ? AND lat BETWEEN ? AND ? AND lng BETWEEN ? AND ?', 
        params[:tandem][:type], 
        params[:tandem][:language],
        (params[:tandem][:lat].to_f - 20.0),
        (params[:tandem][:lat].to_f + 20.0),
        (params[:tandem][:lng].to_f - 20.0),
        (params[:tandem][:lng].to_f + 20.0)
      ])
    else
      @tandems = Tandem.find(:all)
    end
  end
  
  def show
    @tandem = Tandem.find(params[:id])
  end
  
  def new
    @tandem = Tandem.new
    @types = {'Tandem partner' => 1, 'Pen pal' => 2}
  end
  
  def create
    @tandem = current_user.tandems.new(params[:tandem])
    if params[:search]
      @tandem.location = (params[:search]).capitalize
    end
    if @tandem.save
      redirect_to(@tandem)
    else
      @types = {'Tandem partner' => 1, 'Pen pal' => 2}
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
    @types = {'Tandem partner' => 1, 'Pen pal' => 2}
  end
    
  def search_create
    map_center = params[:map_center]
    @tandems = Tandem.find_from_gmap_point(map_center, 50) #takes radious as an argument
    render :action => "search"
  end
end
