class UsersController < ApplicationController

  def login
    if request.post?
      if session[:user] = User.authenticate(params[:user][:login], params[:user][:password])
        redirect_to_stored
        flash[:message] = 'login ok'
      else
        flash[:message] = 'login incorrect'
      end
    end
  end

  def logout
    session[:user] = nil
    flash[:message] = 'logout ok'
    redirect_to :action => 'login'
  end

end
