require File.dirname(__FILE__) + '/../spec_helper'

describe SpamQuestionsController, "as guest" do
  fixtures :all
  integrate_views
  
  it_should_require_admin_for_actions :index, :new, :create, :edit, :update, :destroy
end
 
describe SpamQuestionsController, "as admin" do
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
    SpamQuestion.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    SpamQuestion.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(spam_questions_url)
  end
  
  it "edit action should render edit template" do
    get :edit, :id => SpamQuestion.first
    response.should render_template(:edit)
  end
  
  it "update action should render edit template when model is invalid" do
    SpamQuestion.any_instance.stubs(:valid?).returns(false)
    put :update, :id => SpamQuestion.first
    response.should render_template(:edit)
  end
  
  it "update action should redirect when model is valid" do
    SpamQuestion.any_instance.stubs(:valid?).returns(true)
    put :update, :id => SpamQuestion.first
    response.should redirect_to(spam_questions_url)
  end
  
  it "destroy action should destroy model and redirect to index action" do
    spam_question = SpamQuestion.first
    delete :destroy, :id => spam_question
    response.should redirect_to(spam_questions_url)
    SpamQuestion.exists?(spam_question.id).should be_false
  end
end
