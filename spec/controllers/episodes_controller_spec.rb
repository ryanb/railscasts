require File.dirname(__FILE__) + '/../spec_helper'

describe EpisodesController do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => Episode.first
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    Episode.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect to index action when model is valid" do
    Episode.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(episode_path(assigns[:episode]))
  end
  
  it "edit action should render edit template" do
    get :edit, :id => Episode.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    Episode.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Episode.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect to show action when model is valid" do
    Episode.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Episode.first
    response.should redirect_to(episode_path(Episode.first))
  end
  
  it "destroy action should destroy episode and redirect to index action" do
    episode = Episode.first
    delete :destroy, :id => episode
    response.should redirect_to(episodes_path)
    Episode.exists?(episode.id).should be_false
  end
end
