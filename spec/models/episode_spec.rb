require File.dirname(__FILE__) + '/../spec_helper'

describe Episode do
  it "should find published" do
    a = Episode.create!(:published_at => 2.weeks.ago)
    b = Episode.create!(:published_at => 2.weeks.from_now)
    Episode.published.should include(a)
    Episode.published.should_not include(b)
  end
  
  it "should assign tags to episodes" do
    episode = Episode.create!(:tag_names => 'foo bar')
    episode.tags.map(&:name) == %w[foo bar]
    episode.tag_names.should == 'foo bar'
  end
end
