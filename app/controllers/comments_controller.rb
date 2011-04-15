class CommentsController < ApplicationController
  load_and_authorize_resource

  def new
    @comment = Comment.new(:parent_id => params[:parent_id], :episode_id => params[:episode_id], :user => current_user)
  end

  def create
    @comment = current_user.comments.build(params[:comment])
    @comment.request = request
    @comment.save
    respond_to do |format|
      format.html do
        if @comment.errors.present?
          render :new
        else
          redirect_to(episode_path(@comment.episode, :view => "comments"))
        end
      end
      format.js
    end
  end

  def edit
  end

  def update
    @comment.update_attributes(params[:comment])
    respond_to do |format|
      format.html do
        if @comment.errors.present?
          render :edit
        else
          redirect_to(episode_path(@comment.episode, :view => "comments"))
        end
      end
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to episode_path(@comment.episode, :view => "comments") }
      format.js
    end
  end
end
