class Glossary < ActiveRecord::Base
  has_many  :cards
  has_many  :languages
  has_many  :glownerships, :dependent => :destroy
  has_many  :users, :through => :glownerships

  attr_accessor :language_order
  
  def to_param
  normalized_name = title.gsub(' ', '-').gsub(/[^a-zA-Z0-9\_\-\.]/, '')
  "#{self.id}-#{normalized_name.parameterize}"
  end
  
  def find_questions_for_this_session(user, max_cards, max_new_cards)
    logger.debug("-----#{language_order}")
    @todays_questions = Array.new
    old_cards = user.cards.find(:all, :conditions => ["glossary_id = ?" , id])
    #get all questions which have been scheduled for today
    old_cards.each do |card| 
      return @todays_questions if @todays_questions.length >= max_cards 
      knowability = card.knowabilities.find_by_user_id(user.id)
      
      if( knowability.scheduled_in <= ((Time.now.to_date - knowability.created_at.to_date).to_i) )
        @todays_questions.push(card)
        logger.debug("----added with N = #{knowability.scheduled_in}")
        
      elsif (knowability.ef.to_f <= 2.5)
        logger.debug("----added with EF = #{knowability.ef}")
        @todays_questions.push(card)
      end
    end
    
  new_cards = cards.find( :all,
                          :joins => "LEFT JOIN knowabilities
                                      ON cards.id = knowabilities.card_id",
                          :conditions => ["knowabilities.id is null" , user.id],
                          :limit => max_new_cards
                          )
  logger.debug("----new cards = #{new_cards.length}")
  @todays_questions += new_cards
  
  if @language_order == "reversed"
    @todays_questions.each { |question|
      q = question.question
      question.question = question.answer
      question.answer = q            
    }
  end
  return @todays_questions
  end
      
  def find_from_language
    Language.find(self.from_language).name
  end
  
  def find_to_language
    Language.find(self.to_language).name
  end
end
