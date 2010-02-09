class GlossariesController < ApplicationController
  before_filter :find_parent_user_or_class, :only => [:index]
  before_filter :require_login
  before_filter :can_edit, :only => [:edit, :update, :destroy]

  def index
    @glossaries = current_user.glossaries.find(:all)
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
    @glossary = current_user.glossaries.new(params[:glossary])
    logger.debug "params: #{params.map}"
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
    redirect_to(glossaries_path)
  end
  
  def import
    from_language = params[:from_language] unless params[:from_language].nil? 
    
    @shared_dictionaries = find_shared_dictionaries(from_language)
    
    @my_dictionary = current_user.glossaries.new
    @languages = Language.find(:all, :order => "name").collect {|l| [l.name, l.id] }
    @questions = @shared_dictionaries.first.cards
    @count = @questions.count
    
    respond_to do |format|
      format.html # import.html
      format.xml  { render :xml => @dictionary }
    end
  end
  
  def update_list
    @my_dictionary = current_user.glossaries.new
    @shared_dictionaries =  find_shared_dictionaries(params[:from_language])
    
    @count = Card.find(   :all,
                              :conditions => "glossary_id = #{@shared_dictionaries.first.id}"
                              ).size unless @shared_dictionaries.first.nil?
    
    @questions = Card.find( :all,
                                :conditions => "glossary_id = #{@shared_dictionaries.first.id}",
                                :limit => 10) unless @shared_dictionaries.first.nil?
    
    render :update do |page|
      page.replace_html :dictionary_list,
                        :partial => 'import_dictionaries_list',
                        :locals => {  :shared_dictionaries => @shared_dictionaries,
                                      :my_dictionary => @my_dictionary}
                        
      #page.replace_html :questions_list,
       #                 :partial => 'glossary_questions_list',
        #                :locals => { :questions => @questions, :count => @count }
    end
  end
  
  private
  def find_shared_dictionaries(language)
    if language.eql?("---")
      language = nil
    end
    
    if !language.nil?
      shared_dictionaries = Glossary.find(:all,
                                              :conditions =>
                                            { :from_language => language,
                                              :user_id => '1'} )
    else
      shared_dictionaries = Glossary.find(:all,
                                              :conditions => {:user_id => '1'} )
    end
    shared_dictionaries
  end
end
