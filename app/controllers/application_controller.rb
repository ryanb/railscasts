# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'fc8393e85d1780ae56953606f53014e1'
  
  include HoptoadNotifier::Catcher if APP_CONFIG['hoptoad_key']
  
  private
  
  def admin?
    session[:admin]
  end
  helper_method :admin?
  
  def authorize
    unless admin?
      flash[:error] = "Not authorized to access this page."
      redirect_to root_url
    end
  end
end
