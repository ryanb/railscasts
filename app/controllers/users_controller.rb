class UsersController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def create
    omniauth = request.env["omniauth.auth"]
    logger.info omniauth.inspect
    @user = User.find_by_github_uid(omniauth["uid"]) || User.create_from_omniauth(omniauth)
    cookies.permanent[:token] = @user.token
    redirect_to_target_or_default root_url, :notice => "Signed in successfully"
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to @user, :notice => "Successfully updated user."
    else
      render :action => "edit"
    end
  end

  def login
    session[:return_to] = params[:return_to] if params[:return_to]
    if Rails.env.development?
      cookies.permanent[:token] = User.first.token
      redirect_to_target_or_default root_url, :notice => "Signed in successfully"
    else
      redirect_to "/auth/github"
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "You have been logged out."
  end
end
