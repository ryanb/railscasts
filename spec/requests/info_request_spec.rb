require 'spec_helper'

describe "Info request" do
  it "has about page" do
    visit about_path
    page.should have_content("About RailsCasts")
  end
end
