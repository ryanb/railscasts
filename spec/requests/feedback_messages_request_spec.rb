require 'spec_helper'

describe "FeedbackMessages request" do
  it "sends an email to feedback@railscasts.com when feedback is submitted" do
    visit feedback_path
    click_button "Send"
    page.should have_content("Invalid Fields")
    fill_in "Name", :with => "Foo"
    fill_in "Email", :with => "foo@example.com"
    fill_in "Message", :with => "Hello"
    click_button "Send"
    page.should have_content("Thank you for the feedback.")
    ActionMailer::Base.deliveries.count.should == 1
  end
end
