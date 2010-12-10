class SponsorsController < ApplicationController
  before_filter :authorize

  def index
    @sponsors = Sponsor.find(:all)
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Sponsor.new(params[:sponsor])
    if @sponsor.save
      redirect_to sponsors_url, :notice => "Successfully created sponsor."
    else
      render 'new'
    end
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
  end

  def update
    @sponsor = Sponsor.find(params[:id])
    if @sponsor.update_attributes(params[:sponsor])
      redirect_to sponsors_url, :notice => "Successfully updated sponsor."
    else
      render 'edit'
    end
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    redirect_to sponsors_url, :notice => "Successfully destroyed sponsor."
  end
end
