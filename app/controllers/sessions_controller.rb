class SessionsController < ApplicationController
  def new
  end
  
  def create
    if params[:password] == APP_CONFIG['password']
      flash[:notice] = 'Logged in successfully.'
      session[:admin] = true
      redirect_to root_url
    else
      flash.now[:error] = 'Password is incorrect.'
      render :action => 'new'
    end
  end
  
  def destroy
    reset_session
    redirect_to root_url
  end
end
