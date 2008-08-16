require File.dirname(__FILE__) + '/../spec_helper'
 
describe InfoController do
  fixtures :all
  integrate_views
  
  it "about action should render about template" do
    get :about
    response.should render_template(:about)
  end
  
  it "contest action should render contest template" do
    get :contest
    response.should render_template(:contest)
  end
  
  it "feeds action should render feeds template" do
    get :feeds
    response.should render_template(:feeds)
  end
end
