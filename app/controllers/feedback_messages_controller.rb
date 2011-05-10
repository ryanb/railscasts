class FeedbackMessagesController < ApplicationController
  def new
    @feedback_message = FeedbackMessage.new
    if current_user
      @feedback_message.name = current_user.name
      @feedback_message.email = current_user.email
    end
  end

  def create
    @feedback_message = FeedbackMessage.new(params[:feedback_message])
    if @feedback_message.save
      Mailer.feedback(@feedback_message).deliver
      redirect_to root_url, :notice => "Thank you for the feedback."
    else
      render :new
    end
  end
end
