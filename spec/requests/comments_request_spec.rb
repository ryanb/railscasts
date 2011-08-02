require 'spec_helper'

describe "Comments request" do
  it "creates and replies when not signed in" do
    episode = Factory(:episode, :name => "Blast from the Past")
    visit episode_path(episode)
    click_on "0 Comments"
    click_on "sign in through GitHub"
    page.should have_content("New comment")
    click_on "Post Comment"
    page.should have_content("Invalid Fields")
    fill_in "comment_content", :with => "Hello world!"
    click_on "Post Comment"
    page.should have_content("Blast from the Past")
    page.should have_content("Hello world!")
    click_on "Reply"
    fill_in "comment_content", :with => "Hello back."
    click_on "Post Comment"
    page.should have_content("Hello back.")
  end

  it "send email to original authors when replying to comment" do
    comment = Factory(:comment)
    login
    visit episode_path(comment.episode, :view => "comments")
    click_on "Reply"
    fill_in "comment_content", :with => "Hello back."
    click_on "Post Comment"
    page.should have_content("Hello back.")
    last_email.to.should include(comment.user.email)
  end

  it "creates when banned" do
    login Factory(:user, :banned_at => Time.now)
    visit episode_path(Factory(:episode), :view => "comments")
    page.should have_content("banned")
  end

  it "updates a comment" do
    user = Factory(:user, :admin => true)
    login user
    episode = Factory(:episode, :name => "Blast from the Past")
    comment = Factory(:comment, :content => "Hello world!", :episode_id => episode.id)
    visit episode_path(episode, :view => "comments")
    click_on "Edit"
    fill_in "comment_content", :with => ""
    click_on "Update Comment"
    page.should have_content("Invalid Fields")
    fill_in "comment_content", :with => "Hello back."
    click_on "Update Comment"
    page.should have_content("Hello back.")
    comment.versions(true).size.should eq(2)
    comment.versions.last.whodunnit.to_i.should eq(user.id)
  end

  it "destroys a comment" do
    login Factory(:user, :admin => true)
    episode = Factory(:episode, :name => "Blast from the Past")
    Factory(:comment, :content => "Hello world!", :episode_id => episode.id)
    visit episode_path(episode, :view => "comments")
    click_on "Delete"
    page.should_not have_content("Hello world!")
    click_on "undo"
    page.should have_content("Hello world!")
  end

  it "lists and search recent comments" do
    login Factory(:user, :admin => true)
    Factory(:comment, :content => "Hello world!")
    Factory(:comment, :content => "Back to the Future", :site_url => "http://example.com")
    visit comments_path
    page.should have_content("Hello world!")
    page.should have_content("Back to the Future")
    fill_in "comment_search", :with => "Future"
    click_on "Search Comments"
    page.should_not have_content("Hello world!")
    page.should have_content("Back to the Future")
  end
end
