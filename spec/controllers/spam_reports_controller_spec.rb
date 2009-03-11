require File.dirname(__FILE__) + '/../spec_helper'

describe SpamReportsController, "as guest" do
  it_should_require_admin_for_actions :index, :create, :destroy
end

describe SpamReportsController, "as admin" do
  fixtures :all
  integrate_views
  
  before(:each) do
    session[:admin] = true
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "create action should redirect when model is valid" do
    SpamReport.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(spam_report_url(assigns[:spam_report]))
  end
  
  it "destroy action should destroy model and redirect to index action" do
    spam_report = SpamReport.first
    delete :destroy, :id => spam_report
    response.should redirect_to(spam_reports_url)
    SpamReport.exists?(spam_report.id).should be_false
  end
end
