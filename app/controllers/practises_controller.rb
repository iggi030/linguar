class PractisesController < ApplicationController
  def new
    @settings[:max_total_cards] = 30
    @settings[:max_new_cards] = 15
  end
  
  def create
    glossary = current_user.glossaries.find(params[:glossary_id])
    @cards = glossary.find_questions_for_this_session(current_user,params[:catalogue][:max_total_cards].to_i, params[:catalogue][:max_new_cards].to_i)
    render :show
  end
  
  def update_scores
    if request.xhr?
      results = ActiveSupport::JSON.decode(params[:data])
      results.each do |result|
        if Knowability.find_by_card_id(result["id"]).nil?
          @knowability = Knowability.new( :card_id => result["id"],
                                          :user_id => @current_user.id,
                                          :n => 1,
                                          :ef => 2.5,
                                          :scheduled_in => 0
                                          )
         else
          @knowability = Knowability.find_by_card_id(result["id"])     
          new = @knowability.calculate_new_factors(result["score"])
          @knowability.n = new[:n]
          @knowability.ef = new[:ef]
          @knowability.scheduled_in = new[:i]
        end
        
        if @knowability.save
          logger.debug @knowability.inspect
        end
      end  
    end
  end
end
