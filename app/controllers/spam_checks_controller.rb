class SpamChecksController < ApplicationController
  before_filter :admin_required

  def index
    @spam_checks = SpamCheck.all
  end

  def new
    @spam_check = SpamCheck.new
  end

  def create
    @spam_check = SpamCheck.new(params[:spam_check])
    if @spam_check.save
      redirect_to spam_checks_url, :notice => "Successfully created spam check."
    else
      render :action => 'new'
    end
  end

  def edit
    @spam_check = SpamCheck.find(params[:id])
  end

  def update
    @spam_check = SpamCheck.find(params[:id])
    if @spam_check.update_attributes(params[:spam_check])
      redirect_to spam_checks_url, :notice => "Successfully updated spam check."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @spam_check = SpamCheck.find(params[:id])
    @spam_check.destroy
    redirect_to spam_checks_url, :notice => "Successfully destroyed spam check."
  end
end
