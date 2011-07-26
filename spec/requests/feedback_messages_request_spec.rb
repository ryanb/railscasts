require 'spec_helper'

describe "FeedbackMessages request" do
  before(:each) do
    ActionMailer::Base.deliveries = []
  end

  it "sends an email to feedback@railscasts.com when feedback is submitted" do
    visit feedback_path
    click_button "Send"
    page.should have_content("Invalid Fields")
    fill_in "Name", :with => "Foo"
    fill_in "Email Address", :with => "foo@example.com"
    fill_in "Message", :with => "Hello"
    click_button "Send"
    page.should have_content("Thank you for the feedback.")
    ActionMailer::Base.deliveries.count.should eq(1)
  end

  it "includes logged in user email and name" do
    login Factory(:user, :name => "Foo Test", :email => "footest@example.com")
    visit feedback_path
    find_by_id("feedback_message_name").value.should eq("Foo Test")
    find_by_id("feedback_message_email").value.should eq("footest@example.com")
  end

  it "does not send an email when filling out fake email field (honeypot)" do
    ActionMailer::Base.deliveries = []
    visit feedback_path
    fill_in "email", :with => "foo@example.com"
    fill_in "Name", :with => "Foo"
    fill_in "Email Address", :with => "foo@example.com"
    fill_in "Message", :with => "Hello"
    click_button "Send"
    page.should have_content("caught")
    ActionMailer::Base.deliveries.count.should eq(0)
  end
end
