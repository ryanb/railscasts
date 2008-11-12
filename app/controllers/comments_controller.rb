class CommentsController < ApplicationController
  before_filter :authorize, :only => [:edit, :update, :destroy]
  
  def index
    @comments = Comment.recent.all(:limit => 30)
    respond_to do |format|
      format.html
      format.rss
    end
  end
  
  def new
    flash[:notice] = "To submit a comment, please go to a specific episode first."
    redirect_to root_url
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if params[:preview_button].nil? && params[:not_spam] && params[:email].blank? # fake email to catch spammers
      @comment.request = request
      if @comment.save
        flash[:notice] = "Successfully created comment."
        redirect_to @comment.episode
      else
        render :action => 'new'
      end
    else
      flash.now[:error] = "Caught by spam filter. Make sure javascript is enabled. If it still doesn't work, please let me know: ryan [at] railscasts [dot] com." unless params[:preview_button]
      render :action => 'new'
    end
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment.episode
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to comments_path
  end
end
