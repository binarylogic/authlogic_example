class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :forgot_password, :request_password_reset, :edit_password, :update_password]
  before_filter :require_user, :only => [:show, :edit, :update]
  before_filter :load_user_using_password_reset_token, :only => [:edit_password, :update_password]
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def request_password_reset
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. Please check your email."
      redirect_to default_url
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :forgot_password
    end
  end
  
  def update_password
    @user.password = params[:user][:password]
    @user.confirm_password = params[:user][:confirm_password]
    if @user.save
      flash[:notice] = "Password successfully updated"
      redirect_to account_url
    else
      render :action => :edit_password
    end
  end

  private
    def load_user_using_password_reset_token
      @user = User.find_using_password_reset_token(params[:password_reset_token])
      unless @user
        flash[:notice] = "We're sorry, but we could not locate your account. If you are having issues try copying and pasting the URL from your email into your browser or restarting the reset password process."
        redirect_to default_url
      end
    end
end
