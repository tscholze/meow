class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale
  before_filter :redirect_mobile

  def set_locale
    I18n.locale = 'de'
  end

  def login_required
    if session[:user]
      return true
    end
    flash[:notice] = 'please login'
    session[:return_to] = request.url
    redirect_to :controller => :users, :action => :login
    return false 
  end

  def current_user
    session[:user]
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to] = nil
      redirect_to return_to
    else
      redirect_to :controller => :cats, :action => :index
    end
  end

  def redirect_mobile
    if request.user_agent =~ /Mobile|webOS/ && request.subdomain[/^m(\.\w+)?$/].nil?
      redirect_to "http://m.#{ request.host + request.original_fullpath }"
    end
  end

end
