class CataloguesController < ApplicationController
   def show
     @languages = Language.find(:all)
     @glossaries = Glossary.find(:all, :conditions => {:public => true})
   end
   
   def new
      @languages = Language.find(:all)
   end
   
   def create
     @language = params[:language]
     @glossaries = Glossary.find(:all, :conditions => ['(`from_language` = ? OR `to_language` = ?) AND `public` = ?', @language, @language, true])
  
     @glossaries = Glossary.find(:all) if admin?
  
     @languages = Language.find(:all)
    render :show
   end
   
   def update
      language = params[:language]
      @glossaries = Glossary.find(:all, :conditions => {:from_language => language,
                                                        :to_language => language,
                                                        :public => true})   
      render :show
   end
    
end
