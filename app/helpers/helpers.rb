class Helpers
    def self.current_user(session)
      @user = User.find_by_id(session[:user_id])
    end
        
    def self.is_logged_in?(session)
      !!session[:user_id]
    end

    def self.reformat_date(str)
      str.split('-').reverse.join('-')
    end

    def self.times_worn(item)
      user_id=item.user_id
      user=User.find_by_id(user_id)
      user.outfits.count { 
        |outfit| outfit.items.include?(item) 
      } 
    end

  def self.cost_per_wear(item)
    if Helpers.times_worn(item)==0
      item.cost
    else
  item.cost.to_f/Helpers.times_worn(item)
    end
  end
        
  end