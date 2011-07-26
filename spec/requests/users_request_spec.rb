require 'spec_helper'

describe "Users request" do
  it "shows profile" do
    user = Factory(:user, :name => "Jack Sparrow", :github_username => "jsparrow")
    visit user_path(user)
    page.should have_content(user.name)
    page.should have_content(user.github_username)
    page.should_not have_content("Edit Profile")
  end

  it "edits current user" do
    user = Factory(:user)
    login user
    visit user_path(user)
    page.should have_content("This is your profile.")
    click_on "Edit Profile"
    fill_in "Name", :with => "Leonardo"
    uncheck "user_email_on_reply"
    click_on "Update Profile"
    page.should have_content("Successfully updated profile")
    page.should have_content("Leonardo")
    user.reload.email_on_reply.should be_false
  end

  it "logs out current user" do
    user = Factory(:user)
    login user
    visit logout_path
    visit user_path(user)
    page.should_not have_content("This is your profile.")
  end

  it "logs in existing user and redirects to return_to parameter" do
    user = Factory(:user)
    OmniAuth.config.add_mock(:github, "uid" => user.github_uid)
    visit login_path(:return_to => user_path(user))
    page.should have_content("This is your profile.")
  end

  it "logs in unknown profile and creates user" do
    User.count.should be_zero
    OmniAuth.config.add_mock(:github, "uid" => "54321")
    visit login_path
    page.current_path.should eq("/")
    User.count.should eq(1)
    User.last.github_uid.should eq("54321")
  end

  it "bans user as moderator" do
    user = Factory(:user, :moderator => true)
    login user
    bad_user = Factory(:user)
    comment = Factory(:comment, :user => bad_user)
    visit episode_path(comment.episode, :view => "comments")
    click_on "Ban User"
    bad_user.reload.should be_banned
    bad_user.comments.size.should eq(0)
  end

  it "unsubscribe a user from comment replies" do
    user = Factory(:user)
    visit unsubscribe_path(user.generated_unsubscribe_token)
    page.should have_content("unsubscribed")
    user.reload.email_on_reply.should be_false
  end
end
