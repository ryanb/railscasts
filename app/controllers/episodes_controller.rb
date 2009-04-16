class EpisodesController < ApplicationController
  before_filter :authorize, :only => [:new, :create, :edit, :update, :destroy]
  
  def index
    if params[:search].blank?
      @episodes = Episode.published.recent
    else
      @episodes = Episode.search_published(params[:search])
    end
    respond_to do |format|
      format.html { @episodes = @episodes.paginate(:page => params[:page], :per_page => 10) }
      format.rss
    end
  end
  
  def archive
    if params[:search].blank?
      episodes = Episode.published.recent
    else
      episodes = Episode.search_published(params[:search]).sort_by(&:published_at).reverse
    end
    @episode_months = episodes.group_by(&:published_month)
  end

  def show
    if admin?
      @episode = Episode.find_by_position!(params[:id].to_i)
    else
      @episode = Episode.published.find_by_position!(params[:id].to_i)
    end
    if params[:id] != @episode.to_param
      headers["Status"] = "301 Moved Permanently"
      redirect_to episode_url(@episode)
    else
      @comment = Comment.new(:episode => @episode)
      respond_to do |format|
        format.html
        format.rss
      end
    end
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
      render 'new'
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
      render 'edit'
    end
  end

  def destroy
    @episode = Episode.find(params[:id])
    @episode.destroy
    flash[:notice] = "Successfully destroyed episode."
    redirect_to episodes_path
  end
end
