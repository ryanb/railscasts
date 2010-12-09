class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def admin?
    current_user && current_user.admin?
  end
  helper_method :admin?

  def authorize
    unless admin?
      flash[:error] = "Not authorized to access this page."
      redirect_to root_url
    end
  end

  def current_spam_question
    @current_spam_question ||= SpamQuestion.find(session[:spam_question_id]) if session[:spam_question_id]
  end
  helper_method :current_spam_question

  def current_user
    @current_user ||= User.find_by_token(cookies[:token]) if cookies[:token]
  end

  def login_required
    unless current_user
      flash[:error] = "You must first sign in before accessing this page."
      store_target_location
      redirect_to root_url
    end
  end

  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def store_target_location
    session[:return_to] = request.url
  end
end
