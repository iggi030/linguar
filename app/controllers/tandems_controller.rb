class TandemsController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login, :only => [:new]
  
  def index
    page = params[:page] || 1
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
    
end
