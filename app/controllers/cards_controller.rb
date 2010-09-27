class CardsController < ApplicationController
  
  def index
  page = params[:page] || 1
    @glossary = Glossary.find(params[:glossary_id])
    @cards = Card.paginate(:all,  :conditions => ['glossary_id = ?', params[:glossary_id].to_i ], :page => page, :order => 'created_at DESC' )
    @page = page
    if !logged_in?
      render :action => "public"
    end
  end

  def edit
    @card = Card.find(params[:id]) 
  end

  def create
    @card = Card.new(params[:card])
    @card.glossary_id = params[:glossary_id]
    if @card.save
        flash[:notice] = 'Card was successfully created.'
        redirect_to glossary_cards_url(@card.glossary_id) 
    else
        flash[:notice] = 'Sorry, could not save'
        redirect_to glossary_cards_url(@card.glossary_id)
    end
  end

  def update
    @card = Card.find(params[:id])
       
    if @card.update_attributes(params[:card])
      flash[:notice] = 'Question was successfully updated.'
      redirect_to glossary_cards_url(@card.glossary_id)
    else
      render :action => "edit"
    end
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    logger.debug("_-__-__- killed..")
    respond_to do |format|
      format.html { redirect_to glossary_cards_url(@card.glossary_id)  }
      format.xml  { head :ok }
    end
  end
end
