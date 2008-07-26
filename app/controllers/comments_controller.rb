class CommentsController < ApplicationController
  before_filter :authorize, :only => [:edit, :update, :destroy]
  
  def index
    @comments = Comment.find(:all, :limit => 30)
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    if params[:not_spam]
      @comment.request = request
      if @comment.save
        flash[:notice] = "Successfully created comment."
        redirect_to @comment.episode
      else
        render :action => 'new'
      end
    else
      flash.now[:error] = "Caught by spam filter. Make sure javascript is enabled. If it still doesn't work, please let me know: ryan [at] railscasts [dot] com."
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
