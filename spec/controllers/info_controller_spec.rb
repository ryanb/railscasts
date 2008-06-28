require File.dirname(__FILE__) + '/../spec_helper'
 
describe InfoController do
  fixtures :all
  integrate_views
  
  it "about action should render about template" do
    get :about
    response.should render_template(:about)
  end
end
