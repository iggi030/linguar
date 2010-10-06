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
     @glossaries = Glossary.find(:all, :conditions => {:from_language => @language,
                                                       :to_language => @language,
                                                       :public => true})   
     @glossaries = Glossary.find(:all, :conditions => ["from_language = ? or 'to_language' = ? and 'public' = ?", @language, @language, true])
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
