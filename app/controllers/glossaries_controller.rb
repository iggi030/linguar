require 'nokogiri'

class GlossariesController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login, :except => [:index]
  #before_filter :can_edit, :only => [:edit, :update, :destroy]

  def index
    if logged_in?
      @glossaries = current_user.glossaries.find(:all)
    end
  end
  
  def show
    @glossary = current_user.glossaries.find(params[:id])
  end

  def new
    @glossary = current_user.glossaries.new
  end
  
  def edit
    @glossary = Glossary.find(params[:id])
  end
  
  def create
    @glossary = Glossary.new(params[:glossary])
    logger.debug "params: #{params.map}"
    if @glossary.save
      current_user.glossaries << @glossary
      if params[:attachment]
        f = params[:attachment][:file].read
        doc = Nokogiri::XML(f)
        doc.root.children.each do |node|
          if node.name == 'item'
            node.children.each do |sub_e|
              @question = sub_e.inner_text if sub_e.name == 'Q'
              @answer = sub_e.inner_text if sub_e.name == 'A'
            end            
          @glossary.cards.create(:question => @question, :answer =>@answer)
          end
        end
      end    
      redirect_to(@glossary)
    else
      render :action => "new"
    end
  end
  
  def update
    @glossary = Glossary.find(params[:id])
    if @glossary.update_attributes(params[:glossary])
      redirect_to(@glossary)
    else
      render :action => "edit"
    end
  end

  def destroy
    @glossary = current_user.glossaries.find(params[:id])
    if @glossary.shared?
      current_user.glossaries.delete(@glossary)
    else
      @glossary.cards.destroy_all
      @glossary.destroy
    end
    
    redirect_to(glossaries_path)
  end
  
  def add_shared
    current_user.glossaries << Glossary.find(params[:id])
    redirect_to(glossaries_path)
  end
  
  def clone
    this_glossary = Glossary.find(params[:id])  
    
    new_glossary = this_glossary.clone
    new_glossary.public = false
    new_glossary.shared = false
    new_glossary.save
    
    this_glossary.cards.each do |card|
      new_card = card.clone
      new_card.glossary_id = new_glossary.id
      new_card.save
    end
    
    current_user.glossaries << new_glossary
    redirect_to(glossaries_path)
  end
end
