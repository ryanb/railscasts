class SpamReportsController < ApplicationController
  before_filter :authorize
  
  def index
    @spam_reports = SpamReport.unconfirmed
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
end
