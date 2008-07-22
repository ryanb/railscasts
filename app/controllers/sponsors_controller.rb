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
      flash[:notice] = "Successfully created sponsor."
      redirect_to sponsors_url
    else
      render :action => 'new'
    end
  end
  
  def edit
    @sponsor = Sponsor.find(params[:id])
  end
  
  def update
    @sponsor = Sponsor.find(params[:id])
    if @sponsor.update_attributes(params[:sponsor])
      flash[:notice] = "Successfully updated sponsor."
      redirect_to sponsors_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    flash[:notice] = "Successfully destroyed sponsor."
    redirect_to sponsors_url
  end
end
