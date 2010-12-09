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
    redirect_to root_url, :notice => "Signed in successfully"
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user."
      redirect_to root_url
    else
      render :action => "edit"
    end
  end

  def logout
    cookies.delete(:token)
    redirect_to root_url, :notice => "You have been logged out."
  end
end
