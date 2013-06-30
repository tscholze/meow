class UsersController < ApplicationController

  before_filter :login_required, :except => [:login]
  
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.update_attributes(user_params)
    if @user.save
      flash[:message] = 'user has been created'
      redirect_to :action => :index
    else
      flash[:message] = 'error creating user'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(user_params)
    if @user.save
      flash[:message] = 'user has been updated'
      redirect_to :action => :index
    else
      flash[:message] = 'error updating user'
      render :new
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    redirect_to :action => :index
  end

  def login
    if request.post?
      if session[:user] = User.authenticate(user_params[:login], user_params[:password])
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
  
  private
  
  def user_params
    params.require(:user).permit(:login, :email, :firstname, :lastname, :password, :password_confirmation, :admin, :can_upload_image, :can_delete_image)
  end

end
