class EpisodesController < ApplicationController
  before_filter :authorize, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    @episodes = Episode.published.recent
    respond_to do |format|
      format.html { @episodes = @episodes.paginate(:page => params[:page], :per_page => 10) }
      format.rss
    end
  end
  
  def archive
    @episode_months = Episode.published.by_month
  end

  def show
    if admin?
      @episode = Episode.find(params[:id])
    else
      @episode = Episode.published.find(params[:id])
    end
    @comment = Comment.new(:episode => @episode)
  end

  def new
    @episode = Episode.new
    @episode.downloads.build(:format => 'mov')
    @episode.downloads.build(:format => 'm4v')
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
