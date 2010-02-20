class GamesController < ApplicationController
  def index
    @settings[:max_cards] = 30
    @settings[:max_new_cards] = 15
  end
  
  def play
    
  end
end
