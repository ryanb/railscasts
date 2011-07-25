require "spec_helper"

describe User do
  it "should create unique token when saving" do
    User.create!.token.should_not == User.create!.token
  end

  it "should create from omniauth hash" do
    omniauth = {"provider" => "github", "uid" => "123", "user_info" => {}, "extra" => {"user_hash" => {}}}
    omniauth["user_info"]["email"] = "foo@example.com"
    omniauth["user_info"]["name"] = "Bar"
    omniauth["user_info"]["nickname"] = "foo"
    omniauth["user_info"]["urls"] = {"GitHub" => "githubsite", "Blog" => "customsite"}
    omniauth["extra"]["user_hash"]["gravatar_id"] = "avatar"
    user = User.create_from_omniauth(omniauth)
    user.email.should == "foo@example.com"
    user.github_uid.should == "123"
    user.github_username.should == "foo"
    user.name.should == "Bar"
    user.gravatar_token.should == "avatar"
    user.site_url.should == "customsite"
    user.email_on_reply.should be_true
    user
  end

  it "should generate persistant unsubscribe_token" do
    user = Factory(:user)
    user.unsubscribe_token.should be_nil
    token = user.generated_unsubscribe_token
    user.reload.unsubscribe_token.should eq(token)
    user.generated_unsubscribe_token.should eq(token)
  end
end
