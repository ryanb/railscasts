require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  fixtures :all
  render_views

  it "show action should render show template" do
    get :show, :id => User.first
    response.should render_template(:show)
  end

  it "edit action should render edit template" do
    user = User.create!
    @controller.stubs(:current_user).returns(user)
    get :edit, :id => user
    response.should render_template(:edit)
  end

  it "update action should render edit template when model is invalid" do
    user = User.create!
    user.stubs(:valid?).returns(false)
    @controller.stubs(:current_user).returns(user)
    put :update, :id => user
    response.should render_template(:edit)
  end

  it "update action should redirect when model is valid" do
    user = User.create!
    user.stubs(:valid?).returns(true)
    @controller.stubs(:current_user).returns(user)
    put :update, :id => user
    response.should redirect_to(user_path(user))
  end

  it "create action should sign in user when exists" do
    User.delete_all
    request.env["omniauth.auth"] = {"provider" => "github", "uid" => "foobar"}
    user = User.new
    user.github_uid = "foobar"
    user.save!
    post :create
    response.should redirect_to(root_url)
    cookies["token"].should == user.token
  end

  it "create action should create user when new" do
    User.delete_all
    request.env["omniauth.auth"] = {"provider" => "github", "uid" => "foobar", "user_info" => {"email" => "foo@example.com", "name" => "Foo Bar"}}
    post :create
    response.should redirect_to(root_url)
    assigns[:user].name.should == "Foo Bar"
  end

  it "login action should redirect to /auth/github and remember return_to param" do
    get :login, :return_to => "/foo"
    response.should redirect_to("/auth/github")
    session[:return_to].should == "/foo"
  end

  it "logout action should remove token cookie" do
    login_as Factory(:user)
    get :logout
    response.should redirect_to(root_url)
    cookies["token"].should be_nil
  end
end
