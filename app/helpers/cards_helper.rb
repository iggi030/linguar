module CardsHelper
  def is_owner?
    current_user == @glossary.users.first
  end
  def in_user_glossary_list?
    current_user.glossaries.exists?(@glossary)
  end
  
  def find_name_for_language(id)
    Language.find_by_id(id).name    
  end
end
