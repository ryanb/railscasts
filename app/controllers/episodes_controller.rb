class EpisodesController < ApplicationController
  def index
    @episode_months = Episode.published.by_month
  end
  
  def recent
    @episodes = Episode.published
  end

  def show
    @episode = Episode.find(params[:id])
    @comment = Comment.new(:episode => @episode)
  end

  def new
    @episode = Episode.new
  end

  def create
    @episode = Episode.new(params[:episode])
    if @episode.save
      flash[:notice] = "Successfully created episode."
      redirect_to @episode
    else
      render :action => 'new'
    end
  end

  def edit
    @episode = Episode.find(params[:id])
  end

  def update
    @episode = Episode.find(params[:id])
    if @episode.update_attributes(params[:episode])
      flash[:notice] = "Successfully updated episode."
      redirect_to @episode
    else
      render :action => 'edit'
    end
  end

  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy
    flash[:notice] = "Successfully destroyed episode."
    redirect_to episodes_path
  end
end
