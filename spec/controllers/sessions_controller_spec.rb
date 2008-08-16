require File.dirname(__FILE__) + '/../spec_helper'
 
describe SessionsController do
  fixtures :all
  integrate_views
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should mark as admin when password is correct" do
    APP_CONFIG['password'] = 'testpass'
    get :create, :password => 'testpass'
    response.should redirect_to(root_url)
    session[:admin].should be_true
  end
  
  it "create action should render new page and not mark as admin when failed" do
    get :create, :password => 'bad'
    response.should render_template(:new)
    session[:admin].should_not be_true
  end
  
  it "destroy action should remove admin session and redirect to root" do
    session[:admin] = true
    get :destroy
    response.should redirect_to(root_url)
    session[:admin].should_not be_true
  end
end
