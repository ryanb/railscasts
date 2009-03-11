class SpamReportsController < ApplicationController
  before_filter :authorize
  
  def index
    @spam_reports = SpamReport.unconfirmed
  end
   
  def create
    @spam_report = SpamReport.new(params[:spam_report])
    @spam_report.save!
    flash[:notice] = "Successfully created spam report."
    redirect_to @spam_report
  end
  
  def destroy
    @spam_report = SpamReport.find(params[:id])
    @spam_report.destroy
    flash[:notice] = "Successfully destroyed spam report."
    redirect_to spam_reports_url
  end
end
