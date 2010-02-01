class GlossariesController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login
  before_filter :can_edit, :only => [:edit, :update, :destroy]

  def index
    @glossaries = current_user.dictionaries.find(:all)
  end
  
  def show
    @glossary = current_user.dictionaries.find(params[:id])
  end

  def new
    @glossary = current_user.dictionaries.new
  end
  
  def edit
    @glossary = Glossary.find(params[:id])
  end
  
  def create
    @glossary = current_user.glossaries.new(params[:glossary])
    if @glossary.save
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
    @glossary = Glossary.find(params[:id])
    @glossary.destroy
    redirect_to(glossary_path)
  end
end
