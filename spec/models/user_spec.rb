require "spec_helper"

describe User do
  it "creates unique token when saving" do
    User.create!.token.should_not == User.create!.token
  end

  it "creates from omniauth hash" do
    omniauth = {"provider" => "github", "uid" => "123", "user_info" => {}, "extra" => {"user_hash" => {}}}
    omniauth["user_info"]["email"] = "foo@example.com"
    omniauth["user_info"]["name"] = "Bar"
    omniauth["user_info"]["nickname"] = "foo"
    omniauth["user_info"]["urls"] = {"GitHub" => "githubsite", "Blog" => "customsite"}
    omniauth["extra"]["user_hash"]["gravatar_id"] = "avatar"
    user = User.create_from_omniauth(omniauth)
    user.email.should eq("foo@example.com")
    user.github_uid.should eq("123")
    user.github_username.should eq("foo")
    user.name.should eq("Bar")
    user.gravatar_token.should eq("avatar")
    user.site_url.should eq("customsite")
    user.email_on_reply.should be_true
    user
  end

  it "generates persistant unsubscribe_token" do
    user = Factory(:user)
    user.unsubscribe_token.should be_nil
    token = user.generated_unsubscribe_token
    user.reload.unsubscribe_token.should eq(token)
    user.generated_unsubscribe_token.should eq(token)
  end

  it "uses github name as display name when original is blank" do
    Factory(:user, :name => "", :github_username => "hank").display_name.should eq("hank")
  end
end
