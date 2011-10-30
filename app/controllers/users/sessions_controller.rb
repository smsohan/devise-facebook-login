class Users::SessionsController < Devise::SessionsController
  
  def destroy
    super
    session[:fb_token] = nil
  end
  
end