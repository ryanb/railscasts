require File.dirname(__FILE__) + '/../spec_helper'
 
describe InfoController do
  it "about action should render about template" do
    get :about
    response.should render_template(:about)
  end
  
  it "contest action should render contest template" do
    get :contest
    response.should render_template(:contest)
  end
end
