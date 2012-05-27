class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default new_user_session_url
  end
  
  private
    def require_user 
      unless current_user 
        store_location 
        flash[:notice] = "You must be logged in to access this page" 
        redirect_to login_path 
        return false 
      end 
    end 
    def require_no_user 
      if current_user 
        store_location 
        flash[:notice] = "You cannot access this page while logged in to another account" 
        redirect_to root_url 
        return false 
      end 
    end
end
