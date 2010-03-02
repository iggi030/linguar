module GlossariesHelper
  def is_owner(glossary)
    current_user == glossary.users.first
  end
end
