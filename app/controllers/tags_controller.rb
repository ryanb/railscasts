class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @episodes = @tag.episodes.published.recent.paginate(:page => params[:page], :per_page => 10)
  end
end
