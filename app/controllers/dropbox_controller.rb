require 'dropbox_sdk'

class DropboxController < ApplicationController
  
  before_filter :init_dropbox_flow, :only => [:associate, :callback]
  
  def init_dropbox_flow
    @flow = DropboxOAuth2Flow.new(APP_KEY, APP_SEC, "https://#{ request.host_with_port }" + dropbox_callback_path, session, :dropbox_auth_csrf_token)
  end
  
  def associate
    authorize_url = @flow.start()
    redirect_to authorize_url
  end
  
  def callback
    access_token, user_id, url_state = @flow.finish(params)
    user = User.find(session[:user][:id])
    user.update_attributes!({
      :dropbox_user_id      => user_id,
      :dropbox_access_token => access_token
    })
    session[:user] = user
    redirect_to '/'
  end
  
end
