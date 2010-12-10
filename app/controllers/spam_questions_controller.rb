class SpamQuestionsController < ApplicationController
  before_filter :authorize

  def index
    @spam_questions = SpamQuestion.all
  end

  def new
    @spam_question = SpamQuestion.new
  end

  def create
    @spam_question = SpamQuestion.new(params[:spam_question])
    if @spam_question.save
      redirect_to spam_questions_url, :notice => "Successfully created spam question."
    else
      render :action => 'new'
    end
  end

  def edit
    @spam_question = SpamQuestion.find(params[:id])
  end

  def update
    @spam_question = SpamQuestion.find(params[:id])
    if @spam_question.update_attributes(params[:spam_question])
      redirect_to spam_questions_url, :notice => "Successfully updated spam question."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @spam_question = SpamQuestion.find(params[:id])
    @spam_question.destroy
    redirect_to spam_questions_url, :notice => "Successfully destroyed spam question."
  end
end
