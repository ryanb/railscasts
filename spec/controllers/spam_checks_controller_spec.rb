require File.dirname(__FILE__) + '/../spec_helper'

describe SpamChecksController, "as guest" do
  fixtures :all
  render_views
  
  it_should_require_admin_for_actions :index, :new, :create, :edit, :update, :destroy
end
 
describe SpamChecksController, "as admin" do
  fixtures :all
  render_views
  
  before(:each) do
    session[:admin] = true
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    SpamCheck.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    SpamCheck.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(spam_checks_url)
  end
  
  it "edit action should render edit template" do
    get :edit, :id => SpamCheck.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    SpamCheck.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SpamCheck.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    SpamCheck.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SpamCheck.first
    response.should redirect_to(spam_checks_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    spam_check = SpamCheck.first
    delete :destroy, :id => spam_check
    response.should redirect_to(spam_checks_url)
    SpamCheck.exists?(spam_check.id).should be_false
  end
end
