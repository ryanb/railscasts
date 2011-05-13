class FeedbackMessagesController < ApplicationController
  def new
    @feedback_message = FeedbackMessage.new
    if current_user
      @feedback_message.name = current_user.name
      @feedback_message.email = current_user.email
    end
  end

  def create
    if params[:email].present?
      redirect_to root_url, :notice => "Your feedback message was caught by the spam filter because you filled in the invisible email field. Please try again without filling in the false email field and let me know that this happened."
    else
      @feedback_message = FeedbackMessage.new(params[:feedback_message])
      if @feedback_message.save
        Mailer.feedback(@feedback_message).deliver
        redirect_to root_url, :notice => "Thank you for the feedback."
      else
        render :new
      end
    end
  end
end
