require File.dirname(__FILE__) + '/../spec_helper'

describe EpisodesController, "as guest" do
  fixtures :all
  integrate_views
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "index action with search should search published episodes" do
    Episode.expects(:search_published).with('foo').returns(Episode.all)
    get :index, :search => 'foo'
  end
  
  it "index action with blank search should not search episodes" do
    Episode.expects(:search_published).never
    get :index, :search => ''
  end
  
  it "index action should render index template for rss with xml" do
    get :index, :format => 'rss'
    response.should render_template(:index)
    response.content_type.should == 'application/rss+xml'
    response.should have_tag('title', :text => 'Railscasts')
  end
  
  it "index action should render index template for rss with xml for iPod" do
    get :index, :format => 'rss', :ipod => true
    response.should render_template(:index)
    response.content_type.should == 'application/rss+xml'
    response.should have_tag('title', :text => /Railscasts.+iPod/)
  end
  
  it "archive action should render archive template" do
    get :archive
    response.should render_template(:archive)
  end
  
  it "archive action with search should search published episodes" do
    Episode.expects(:search_published).with('foo').returns(Episode.all)
    get :archive, :search => 'foo'
  end
  
  it "show action should render show template" do
    get :show, :id => Episode.first
    response.should render_template(:show)
  end
  
  it "show action should not find episode when unpublished" do
    episode = Factory(:episode, :published_at => 2.weeks.from_now)
    lambda { get :show, :id => episode }.should raise_error(ActiveRecord::RecordNotFound)
  end
  
  it "show action should render show template for rss with xml" do
    get :show, :id => Episode.first, :format => 'rss'
    response.should render_template(:show)
    response.content_type.should == 'application/rss+xml'
    response.should have_tag('title', :text => /Comments/)
    response.should have_tag('item description', :text => Episode.first.comments.first.content)
  end
  
  it_should_require_admin_for_actions :new, :create, :edit, :update, :destroy
end
  
describe EpisodesController, "as admin" do
  fixtures :all
  integrate_views
  
  before(:each) do
    session[:admin] = true
  end

  it "show action should render show template when unpublished" do
    episode = Factory(:episode, :published_at => 2.weeks.from_now)
    lambda { get :show, :id => episode }.should_not raise_error(ActiveRecord::RecordNotFound)
    response.should render_template(:show)
  end
  
  it "new action should render new template" do
    get :new
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Episode.any_instance.stub(:valid? => false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect to index action when model is valid" do
    Episode.any_instance.stub(:valid? => true)
    post :create
    response.should redirect_to(episode_path(assigns[:episode]))
  end

  it "edit action should render edit template" do
    get :edit, :id => Episode.first
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    Episode.any_instance.stub(:valid? => false)
    put :update, :id => Episode.first
    response.should render_template(:edit)
  end

  it "update action should redirect to show action when model is valid" do
    Episode.any_instance.stub(:valid? => true)
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
