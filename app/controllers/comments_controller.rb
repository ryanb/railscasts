class CommentsController < ApplicationController
  before_filter :authorize, :only => [:edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token, :only => :destroy

  def index
    @comments = Comment.recent.all(:limit => 30)
    respond_to do |format|
      format.html
      format.rss
    end
  end

  def new
    redirect_to root_url, :notice => "To submit a comment, please go to a specific episode first."
  end

  def create
    @comment = Comment.new(params[:comment])
    @comment.request = request
    if params[:preview_button].nil? && check_spam(@comment) && @comment.save
      redirect_to @comment.episode, :notice => "Successfully created comment."
    else
      render 'new'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      redirect_to @comment.episode, :notice => "Successfully updated comment."
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    respond_to do |format|
      format.html { redirect_to comments_path }
      format.js
    end
  end

  private

  def check_spam(comment)
    errors = []
    if comment.spam?
      errors << "Comment rejected. Please email me the content of your comment for approval: ryan at railscasts dot com."
    elsif current_spam_question
      if params[:spam_answer] =~ /#{current_spam_question.answer}/i
        session[:spam_question_id] = nil
      else
        errors << "The given answer is incorrect, please try again."
      end
    elsif comment.spammish?
      errors << "The provided comment looks like spam. Please answer the question below."
      session[:spam_question_id] = SpamQuestion.random.id
    end
    errors << "Javascript must be enabled to submit a comment." if params[:spam_key] != APP_CONFIG['spam_key']
    errors << "Don't fill in the fake email address below, it should be left blank." unless params[:email].blank? # fake email to catch spammers

    unless errors.empty?
      errors << "If it still doesn't work, please let me know: ryan [at] railscasts [dot] com."
      flash.now[:alert] = errors.join(" ")
    end
    errors.empty?
  end
end
