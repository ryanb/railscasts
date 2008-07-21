require File.dirname(__FILE__) + '/../spec_helper'
 
describe CommentsController do
  describe "as guest" do
    it "index action should render index template" do
      get :index
      response.should render_template(:index)
    end
  
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end
  
    it "create action should render new template when model is invalid" do
      Comment.any_instance.stubs(:valid?).returns(false)
      post :create
      response.should render_template(:new)
    end
  
    it "create action should redirect to index action when model is valid" do
      Comment.any_instance.stubs(:valid?).returns(true)
      post :create, :comment => { :episode_id => Episode.first.id }
      response.should redirect_to(episode_path(Episode.first))
    end
    
    it_should_require_admin_for_actions :edit, :update, :destroy
  end
  
  describe "as admin" do
    before(:each) do
      session[:admin] = true
    end
    
    it "edit action should render edit template" do
      get :edit, :id => Comment.first
      response.should render_template(:edit)
    end
  
    it "update action should render edit template when model is invalid" do
      Comment.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Comment.first
      response.should render_template(:edit)
    end
  
    it "update action should redirect to episode page when model is valid" do
      Comment.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Comment.first, :comment => { :episode_id => Episode.first.id }
      response.should redirect_to(episode_path(Episode.first))
    end
  
    it "destroy action should destroy model and redirect to index action" do
      comment = Comment.first
      delete :destroy, :id => comment
      response.should redirect_to(comments_path)
      Comment.exists?(comment.id).should be_false
    end
  end
end
