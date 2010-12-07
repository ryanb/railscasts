require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should create unique token when saving" do
    User.create!.token.should_not == User.create!.token
  end

  it "should create from omniauth hash" do
    omniauth = {"provider" => "github", "uid" => "foo", "user_info" => {}}
    omniauth["user_info"]["email"] = "foo@example.com"
    omniauth["user_info"]["name"] = "Bar"
    omniauth["user_info"]["image"] = "avatar"
    omniauth["user_info"]["urls"] = {"Main" => "site"}
    user = User.create_from_omniauth(omniauth)
    user.email.should == "foo@example.com"
    user.name.should == "Bar"
    user.avatar_url.should == "avatar"
    user.site_url.should == "site"
    user
  end
end
