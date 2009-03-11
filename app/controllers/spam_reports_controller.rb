class SpamReportsController < ApplicationController
  before_filter :authorize, :except => :create
  
  def index
    @spam_reports = SpamReport.unconfirmed
  end
  
  def show
    @spam_report = SpamReport.find(params[:id])
  end
   
  def create
    comment = Comment.find(params[:comment_id])
    SpamReport.report_comment(comment)
    flash[:notice] = "Thank you for reporting this comment as spam."
    redirect_to episode_path(comment.episode_id)
  end
  
  def destroy
    @spam_report = SpamReport.find(params[:id])
    @spam_report.destroy
    flash[:notice] = "Successfully destroyed spam report."
    redirect_to spam_reports_url
  end
  
  def confirm
    @spam_report = SpamReport.find(params[:id])
    @spam_report.confirm!
    flash[:notice] = "Successfully confirmed spam report."
    redirect_to spam_reports_url
  end
end
