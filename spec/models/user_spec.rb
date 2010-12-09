require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should create unique token when saving" do
    User.create!.token.should_not == User.create!.token
  end

  it "should create from omniauth hash" do
    omniauth = {"provider" => "github", "uid" => "123", "user_info" => {}, "extra" => {}}
    omniauth["user_info"]["email"] = "foo@example.com"
    omniauth["user_info"]["name"] = "Bar"
    omniauth["user_info"]["nickname"] = "foo"
    omniauth["user_info"]["urls"] = {"GitHub" => "githubsite", "Blog" => "customsite"}
    omniauth["extra"]["gravatar_id"] = "avatar"
    user = User.create_from_omniauth(omniauth)
    user.email.should == "foo@example.com"
    user.github_uid.should == "123"
    user.github_username.should == "foo"
    user.name.should == "Bar"
    user.gravatar_token.should == "avatar"
    user.site_url.should == "customsite"
    user
  end
end
