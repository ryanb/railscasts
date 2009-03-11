class SpamReportsController < ApplicationController
  before_filter :authorize
  
  def index
    @spam_reports = SpamReport.unconfirmed
  end
  
  def show
    @spam_report = SpamReport.find(params[:id])
  end
   
  def create
    SpamReport.report_comment(Comment.find(params[:comment_id]))
    flash[:notice] = "Successfully created spam report."
    redirect_to spam_reports_url
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
