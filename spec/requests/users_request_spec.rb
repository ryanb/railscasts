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
    click_on "Update Profile"
    page.should have_content("Successfully updated profile")
    page.should have_content("Leonardo")
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
    page.current_path.should == "/"
    User.count.should == 1
    User.last.github_uid.should == "54321"
  end
end
