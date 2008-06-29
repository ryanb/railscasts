class TagsController < ApplicationController
  def show
    @tag = Tag.find(params[:id])
    @episodes = @tag.episodes.published
  end
end
