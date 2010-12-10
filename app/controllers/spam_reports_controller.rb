class SpamReportsController < ApplicationController
  before_filter :admin_required, :except => :create
  skip_before_filter :verify_authenticity_token, :only => :create

  def index
    @spam_reports = SpamReport.unconfirmed.popular
  end

  def show
    @spam_report = SpamReport.find(params[:id])
  end

  def create
    @comment = Comment.find(params[:comment_id])
    SpamReport.report_comment(@comment)
    flash[:notice] = "Thank you for reporting spam."
    respond_to do |format|
      format.html { redirect_to episode_path(@comment.episode_id) }
      format.js
    end
  end

  def destroy
    @spam_report = SpamReport.find(params[:id])
    @spam_report.destroy
    redirect_to spam_reports_url, :notice => "Successfully destroyed spam report."
  end

  def confirm
    @spam_reports = SpamReport.find_all_by_id(params[:id])
    @spam_reports.each(&:confirm!)
    redirect_to spam_reports_url, :notice => "Successfully confirmed spam report."
  end
end
