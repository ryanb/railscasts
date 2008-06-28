require File.dirname(__FILE__) + '/../spec_helper'

describe Episode do
  it "should find published" do
    a = Factory.create(:episode, :published_at => 2.weeks.ago)
    b = Factory.create(:episode, :published_at => 2.weeks.from_now)
    Episode.published.should include(a)
    Episode.published.should_not include(b)
  end
  
  it "should assign tags to episodes" do
    episode = Factory.create(:episode, :tag_names => 'foo bar')
    episode.tags.map(&:name) == %w[foo bar]
    episode.tag_names.should == 'foo bar'
  end
  
  it "should require publication date" do
    episode = Episode.new
    episode.should have(1).error_on(:published_at)
  end
end
