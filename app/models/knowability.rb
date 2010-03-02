class Knowability < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :card
  
  def calculate_new_factors(score) 
    q = score
    prev_i = scheduled_in
    prev_ef = ef.to_f
    logger.debug "old factors = #{n} #{q} #{prev_i} #{prev_ef}"
    logger.debug "new factors = #{new_factors( n, q, prev_i, prev_ef).inspect}"
    new_factors( n, q, prev_i, prev_ef)
  end

  # q - the Quality of the recall 
  # ef - The Easiness Factor
  # i - The scheduled Interval for the item to be recalled, in days. 
  # n - The nth iteration of the recall. An integer, starting at 1. 

  def new_factors(n, q, prev_i = 0, prev_ef = 2.5)
    if q < 3    
      n = 1 
      ef = prev_ef
    else
      n += 1
      ef = new_ef(prev_ef, q)
    end
    
    case n
    when 1
      i = 1
    when 2
      i = 5
    else
      i = prev_i * ef
    end
    return {:i => i, :ef => ef, :n => n}
  end

  private 
  
  def new_ef(ef_old, q)
    ef = ef_old - 0.8 + (0.28*q) - (0.02*q*q)
    ef < 1.3 ? 1.3 : ef
  end
end
