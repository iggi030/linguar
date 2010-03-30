class CataloguesController < ApplicationController
        
   def show
      @glossaries = Glossary.find(:all, :conditions => {:public => true})
   end
   
   def new
      @languages = Language.find(:all)
   end
   
   def create
     @native_language = params[:native_language].join(',')
     @languages = Language.find(:all)
   end
   
   def update
      @native_languages = params[:native_language].split(',')
      @foreign_languages = params[:foreign_language]
      
      @glossaries = Glossary.find(:all, :conditions => {:from_language => @native_languages + @foreign_languages,
                                                        :to_language => @foreign_languages + @native_languages,
                                                        :public => true})
      
      render :show
   end
    
end
