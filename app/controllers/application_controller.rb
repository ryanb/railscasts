class ApplicationController < ActionController::Base
  protect_from_forgery
  
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
  
  def current_spam_question
    @current_spam_question ||= SpamQuestion.find(session[:spam_question_id]) if session[:spam_question_id]
  end
  helper_method :current_spam_question
end
