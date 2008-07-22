require File.dirname(__FILE__) + '/../spec_helper'

describe Episode do
  it "should find published" do
    a = Factory.create(:episode, :published_at => 2.weeks.ago)
    b = Factory.create(:episode, :published_at => 2.weeks.from_now)
    Episode.published.should include(a)
    Episode.published.should_not include(b)
  end
  
  it "should find unpublished" do
    a = Factory.create(:episode, :published_at => 2.weeks.ago)
    b = Factory.create(:episode, :published_at => 2.weeks.from_now)
    Episode.unpublished.should include(b)
    Episode.unpublished.should_not include(a)
  end
  
  it "should sort recent episodes in descending order" do
    Episode.delete_all
    e1 = Factory.create(:episode)
    e2 = Factory.create(:episode)
    Episode.recent.should == [e2, e1]
  end
  
  it "should assign tags to episodes" do
    episode = Factory.create(:episode, :tag_names => 'foo bar')
    episode.tags.map(&:name).should == %w[foo bar]
    episode.tag_names.should == 'foo bar'
  end
  
  it "should require publication date and name" do
    episode = Episode.new
    episode.should have(1).error_on(:published_at)
    episode.should have(1).error_on(:name)
  end
  
  it "should group episodes by month" do
    Episode.delete_all
    a = Factory.create(:episode, :published_at => '2008-01-01')
    b = Factory.create(:episode, :published_at => '2008-01-05')
    c = Factory.create(:episode, :published_at => '2008-02-05')
    months = Episode.by_month
    months[Time.parse('2008-01-01')].should == [a, b]
    months[Time.parse('2008-02-01')].should == [c]
  end
  
  it "should automatically generate permalink when creating episode" do
    episode = Factory.create(:episode, :name => ' Hello_ *World* 2.1. ')
    episode.permalink.should == 'hello-world-2-1'
  end
  
  it "should include id and permalink in to_param" do
    episode = Factory.create(:episode, :name => 'Foo Bar')
    episode.to_param.should == "#{episode.id}-#{episode.permalink}"
  end
  
  it "should know if it's the last published episode" do
    a = Factory.create(:episode, :published_at => 2.weeks.ago)
    b = Factory.create(:episode, :published_at => 1.week.ago)
    c = Factory.create(:episode, :published_at => 2.weeks.from_now)
    a.should_not be_last_published
    b.should be_last_published
    c.should_not be_last_published
  end
  
  describe "with downloads" do
    before(:each) do
      @episode = Factory.create(:episode)
      @mov = @episode.downloads.create!(:format => 'mov')
      @m4v = @episode.downloads.create!(:format => 'm4v')
    end
    
    it "should find mov" do
      @episode.mov.should == @mov
    end
    
    it "should find m4v" do
      @episode.m4v.should == @m4v
    end
  end
end
