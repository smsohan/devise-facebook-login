class User < ActiveRecord::Base
  devise :database_authenticatable, :omniauthable, :rememberable, :validatable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me
  
  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    
    logger.debug "Facebook User data: #{data.inspect}"
    
    if user = User.find_by_email(data["email"])
      user
    else
      User.create(:email => data["email"], :name => data["name"], :password => Devise.friendly_token[0,20]) 
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end
    
end
