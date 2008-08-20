require File.dirname(__FILE__) + '/../spec_helper'
 
describe TagsController do
  fixtures :all
  integrate_views
  
  it "show action should render show template without unpublished episodes" do
    unpublished_episode = Factory(:episode, :published_at => 2.weeks.from_now, :tag_names => Tag.first.name)
    get :show, :id => Tag.first
    response.should render_template(:show)
    assigns[:episodes].should_not include(unpublished_episode)
  end
end
