class TandemsController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login, :except => [:index, :show]
  
  def index
    if params[:tandem]
      @tandems = Tandem.find(:all, :conditions => ['post_type = ?', params[:tandem][:type]] )
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
    if @tandem.save
      redirect_to(@tandem)
    else
      @types = {'Tandem partner' => 1, 'Pen pal' => 2}
      render :action => "new"
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
