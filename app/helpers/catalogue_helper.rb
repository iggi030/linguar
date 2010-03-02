module CatalogueHelper
  
  def find_name_for_language(id)
    Language.find_by_id(id).name    
  end
end
