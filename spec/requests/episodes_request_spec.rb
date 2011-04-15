require 'spec_helper'

describe "Episodes request" do
  it "lists published" do
    Factory(:episode, :name => "Blast from the Past", :published_at => 2.days.ago)
    Factory(:episode, :name => "Back to the Future", :published_at => 2.days.from_now)
    visit episodes_path
    page.should have_content("Blast from the Past")
    page.should_not have_content("Back to the Future")
  end

  it "provides RSS feed of episodes" do
    Factory(:episode, :name => "Blast from the Past", :published_at => 2.days.ago)
    visit episodes_path(:format => :rss)
    page.should have_content("Blast from the Past")
  end

  it "has different views" do
    Factory(:episode, :name => "Blast from the Past", :description => "I am from 1960", :published_at => 2.days.ago)
    visit episodes_path
    page.should have_content("I am from 1960")
    click_on "List View"
    page.should_not have_content("I am from 1960")
    page.should have_content("Duration")
    click_on "Grid View"
    page.should_not have_content("I am from 1960")
    page.should_not have_content("Duration")
  end

  it "searches by name" do
    Factory(:episode, :name => "Blast from the Past")
    Factory(:episode, :name => "Back to the Future")
    visit episodes_path
    fill_in "search", :with => "Blast"
    click_on "Search Episodes"
    page.should have_content("Blast from the Past")
    page.should_not have_content("Back to the Future")
    click_on "remove"
    page.should have_content("Blast from the Past")
    page.should have_content("Back to the Future")
  end

  it "filters by tag" do
    Factory(:episode, :name => "Blast from the Past", :tags => [Factory.build(:tag, :name => "Oldtimes")])
    Factory(:episode, :name => "Back to the Future")
    visit episodes_path
    click_on "Oldtimes"
    page.should have_content("Blast from the Past")
    page.should_not have_content("Back to the Future")
    click_on "remove"
    page.should have_content("Blast from the Past")
    page.should have_content("Back to the Future")
  end

  it "contains show notes, comments, and similar episodes" do
    episode = Factory(:episode, :name => "Blast from the Past", :notes => "Show notes!")
    Factory(:comment, :content => "Hello world", :episode => episode)
    Factory(:episode, :name => "Star Wars")
    Factory(:episode, :name => "Past and Present")
    visit episodes_path
    click_on "Blast from the Past"
    page.should have_content("Blast from the Past")
    page.should have_content("Show notes!")
    page.should_not have_content("Hello world")
    click_on "1 Comment"
    page.should_not have_content("Show notes!")
    page.should have_content("Hello world")
    click_on "Similar Episodes"
    page.should_not have_content("Show notes!")
    page.should_not have_content("Hello world")
    page.should have_content("Past and Present")
    page.should_not have_content("Star Wars")
    click_on "Next Episode"
    page.should have_content("Star Wars")
    click_on "Previous Episode"
    page.should have_content("Blast from the Past")
  end

  it "redirects to episode when full permalink isn't used" do
    episode = Factory(:episode, :name => "Blast from the Past")
    visit episode_path("#{episode.position}-anything")
    page.current_path.should == episode_path("#{episode.position}-#{episode.permalink}")
  end

  it "creates a new episode" do
    login Factory(:user, :admin => true)
    visit episodes_path
    click_on "New Episode"
    click_on "Create"
    page.should have_content("Invalid Fields")
    fill_in "Name", :with => "Blast from the Past"
    fill_in "Duration", :with => "15:23"
    click_on "Create"
    page.current_path.should == episode_path(Episode.last)
    page.should have_content("Blast from the Past")
    page.should have_content("15 minutes")
  end

  it "edits an episode" do
    login Factory(:user, :admin => true)
    episode = Factory(:episode, :name => "Blast from the Past")
    visit episode_path(episode)
    click_on "Edit"
    fill_in "Name", :with => ""
    click_on "Update"
    page.should have_content("Invalid Fields")
    fill_in "Name", :with => "Back to the Future"
    click_on "Update"
    page.current_path.should == episode_path(episode)
    page.should have_content("Back to the Future")
  end
end
