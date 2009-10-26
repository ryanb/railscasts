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
    flash[:notice] = "To submit a comment, please go to a specific episode first."
    redirect_to root_url
  end
  
  def create
    @comment = Comment.new(params[:comment])
    @comment.request = request
    if params[:preview_button].nil? && verify_recaptcha(:model => @comment, :private_key => APP_CONFIG["recaptcha_private_key"]) && @comment.save
      flash[:notice] = "Successfully created comment."
      redirect_to @comment.episode
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
      flash[:notice] = "Successfully updated comment."
      redirect_to @comment.episode
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
end
