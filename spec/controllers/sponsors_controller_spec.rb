require File.dirname(__FILE__) + '/../spec_helper'
 
describe SponsorsController, "as guest" do
  fixtures :all
  integrate_views
  
  it_should_require_admin_for_actions :index, :new, :create, :edit, :update, :destroy
end
  
describe SponsorsController, "as admin" do
  fixtures :all
  integrate_views
  
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
    Sponsor.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect to index action when model is valid" do
    Sponsor.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(sponsors_url)
  end

  it "edit action should render edit template" do
    get :edit, :id => Sponsor.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Sponsor.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Sponsor.first
    response.should render_template(:edit)
  end

  it "update action should redirect to show action when model is valid" do
    Sponsor.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Sponsor.first
    response.should redirect_to(sponsors_url)
  end

  it "destroy action should destroy model and redirect to index action" do
    sponsor = Sponsor.first
    delete :destroy, :id => sponsor
    response.should redirect_to(sponsors_url)
    Sponsor.exists?(sponsor.id).should be_false
  end
end
