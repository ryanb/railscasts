require "spec_helper"

describe Episode do
  it "should find published" do
    a = Factory(:episode, :published_at => 2.weeks.ago)
    b = Factory(:episode, :published_at => 2.weeks.from_now)
    Episode.published.should include(a)
    Episode.published.should_not include(b)
  end

  it "should find unpublished" do
    a = Factory(:episode, :published_at => 2.weeks.ago)
    b = Factory(:episode, :published_at => 2.weeks.from_now)
    Episode.unpublished.should include(b)
    Episode.unpublished.should_not include(a)
  end

  it "should sort recent episodes in descending order" do
    Episode.delete_all
    e1 = Factory(:episode)
    e2 = Factory(:episode)
    Episode.recent.should == [e2, e1]
  end

  it "should assign tags to episodes" do
    episode = Factory(:episode, :tag_names => 'foo bar')
    episode.tags.map(&:name).should == %w[foo bar]
    episode.tag_names.should == 'foo bar'
  end

  it "should require publication date and name" do
    episode = Episode.new
    episode.should have(1).error_on(:published_at)
    episode.should have(1).error_on(:name)
  end

  it "should automatically generate permalink when creating episode" do
    episode = Factory(:episode, :name => ' Hello_ *World* 2.1. ')
    episode.permalink.should == 'hello-world-2-1'
  end

  it "should include position and permalink in to_param" do
    episode = Factory(:episode, :name => 'Foo Bar')
    episode.to_param.should == "#{episode.position}-foo-bar"
  end

  it "should translate single digit seconds into duration with minutes" do
    Episode.new(:seconds => 60*8+3).duration.should == '8:03'
  end

  it "should translate double digit seconds into duration with minutes" do
    Episode.new(:seconds => 60*8+12).duration.should == '8:12'
  end

  it "should return nil for duration if seconds aren't set" do
    Episode.new(:seconds => nil).duration.should be_nil
  end

  it "should parse duration into seconds" do
    Episode.new(:duration => '10:03').seconds.should == 603
    Episode.new(:duration => '').seconds.should be_nil
  end

  it "should know if it's the last published episode" do
    a = Factory(:episode, :published_at => 2.weeks.ago)
    b = Factory(:episode, :published_at => 1.week.ago)
    c = Factory(:episode, :published_at => 2.weeks.from_now)
    a.should_not be_last_published
    b.should be_last_published
    c.should_not be_last_published
  end

  it "has media.railscasts.com asset url" do
    episode = Factory(:episode, :name => "Hello world")
    episode.position = 23
    episode.asset_url("videos").should == "http://media.railscasts.com/assets/episodes/videos/023-hello-world"
    episode.asset_url("videos", "mp4").should == "http://media.railscasts.com/assets/episodes/videos/023-hello-world.mp4"
  end

  it "has files with file sizes" do
    episode = Factory(:episode, :name => "Hello world", :file_sizes => {"zip" => "12345"})
    episode.files[0][:name].should == "source code"
    episode.files.map { |f| f[:name] }.should == ["source code", "mp4", "m4v", "webm", "ogv"]
    episode.files.map { |f| f[:info] }.should == ["Project Files in Zip", "Full Size H.264 Video", "Smaller H.264 Video", "Full Size VP8 Video", "Full Size Theora Video"]
    episode.files[0][:url].should include("http://media.railscasts.com/assets/episodes/sources/")
    episode.files[0][:size].should == 12345
  end

  it "sets file size to zero when unknown" do
    episode = Factory(:episode, :name => "Hello world", :file_sizes => nil)
    episode.files[0][:size].should == 0
  end

  it "loads the file sizes for each file" do
    episode = Factory(:episode, :name => "Hello world")
    episode.position = 42
    %w[mp4 m4v webm ogv].each_with_index do |ext, index|
      FakeWeb.register_uri(:head, "http://media.railscasts.com/assets/episodes/videos/042-hello-world.#{ext}", :content_length => index)
    end
    FakeWeb.register_uri(:head, "http://media.railscasts.com/assets/episodes/sources/042-hello-world.zip", :content_length => 4)
    episode.load_file_sizes
    episode.file_sizes.should == {
      "mp4" => "0",
      "m4v" => "1",
      "webm" => "2",
      "ogv" => "3",
      "zip" => "4",
    }
  end

  it "should return nil as file size when response is not 200" do
    FakeWeb.register_uri(:head, "http://example.com/foo", :content_length => "123", :status => ["404", "Not Found"])
    episode = Factory.build(:episode)
    episode.fetch_file_size("http://example.com/foo").should == nil
  end

  it "has a full name which includes position" do
    Episode.delete_all
    Factory(:episode, :name => "Foo Bar").full_name.should eq('#1 Foo Bar')
  end

  describe "primitive search" do
    before(:each) do
      Episode.delete_all
      APP_CONFIG['thinking_sphinx'] = false
    end

    it "should look in name, description, and notes" do
      e1 = Factory(:episode, :name => 'foo', :description => 'bar', :notes => 'baz', :published_at => 2.weeks.ago)
      e2 = Factory(:episode, :name => 'foo test bar', :description => 'baz', :published_at => 2.weeks.ago)
      e3 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.ago)
      Episode.search_published('foo bar baz').should == [e1, e2]
    end

    it "should not find unpublished" do
      e1 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.ago)
      e2 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.from_now)
      Episode.search_published('foo').should == [e1]
    end
  end
end
