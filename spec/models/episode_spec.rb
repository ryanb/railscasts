require "spec_helper"

describe Episode do
  it "finds published" do
    a = Factory(:episode, :published_at => 2.weeks.ago)
    b = Factory(:episode, :published_at => 2.weeks.from_now)
    Episode.published.should include(a)
    Episode.published.should_not include(b)
  end

  it "finds unpublished" do
    a = Factory(:episode, :published_at => 2.weeks.ago)
    b = Factory(:episode, :published_at => 2.weeks.from_now)
    Episode.unpublished.should include(b)
    Episode.unpublished.should_not include(a)
  end

  it "sorts recent episodes in descending order" do
    Episode.delete_all
    e1 = Factory(:episode, :position => 1)
    e2 = Factory(:episode, :position => 2)
    Episode.recent.should eq([e2, e1])
  end

  it "assigns tags to episodes" do
    episode = Factory(:episode, :tag_names => 'foo bar')
    episode.tags.map(&:name).should eq(%w[foo bar])
    episode.tag_names.should eq('foo bar')
  end

  it "requires publication date and name" do
    episode = Episode.new
    episode.should have(1).error_on(:published_at)
    episode.should have(1).error_on(:name)
  end

  it "automatically generates permalink when creating episode" do
    episode = Factory(:episode, :name => ' Hello_ *World* 2.1. ')
    episode.permalink.should eq('hello-world-2-1')
  end

  it "includes position and permalink in to_param" do
    episode = Factory(:episode, :name => 'Foo Bar')
    episode.to_param.should eq("#{episode.position}-foo-bar")
  end

  it "translates single digit seconds into duration with minutes" do
    Episode.new(:seconds => 60*8+3).duration.should eq('8:03')
  end

  it "translates double digit seconds into duration with minutes" do
    Episode.new(:seconds => 60*8+12).duration.should eq('8:12')
  end

  it "returns nil for duration if seconds aren't set" do
    Episode.new(:seconds => nil).duration.should be_nil
  end

  it "parses duration into seconds" do
    Episode.new(:duration => '10:03').seconds.should eq(603)
    Episode.new(:duration => '').seconds.should be_nil
  end

  it "knows if it's the last published episode" do
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
    episode.asset_url("videos").should eq("http://media.railscasts.com/assets/episodes/videos/023-hello-world")
    episode.asset_url("videos", "mp4").should eq("http://media.railscasts.com/assets/episodes/videos/023-hello-world.mp4")
  end

  it "has files with file sizes" do
    episode = Factory(:episode, :name => "Hello world", :file_sizes => {"zip" => "12345"})
    episode.files[0][:name].should eq("source code")
    episode.files.map { |f| f[:name] }.should eq(["source code", "mp4", "m4v", "webm", "ogv"])
    episode.files.map { |f| f[:info] }.should eq(["Project Files in Zip", "Full Size H.264 Video", "Smaller H.264 Video", "Full Size VP8 Video", "Full Size Theora Video"])
    episode.files[0][:url].should include("http://media.railscasts.com/assets/episodes/sources/")
    episode.files[0][:size].should eq(12345)
  end

  it "sets file size to zero when unknown" do
    episode = Factory(:episode, :name => "Hello world", :file_sizes => nil)
    episode.files[0][:size].should eq(0)
  end

  it "loads the file sizes for each file" do
    episode = Factory(:episode, :name => "Hello world")
    episode.position = 42
    %w[mp4 m4v webm ogv].each_with_index do |ext, index|
      FakeWeb.register_uri(:head, "http://media.railscasts.com/assets/episodes/videos/042-hello-world.#{ext}", :content_length => index)
    end
    FakeWeb.register_uri(:head, "http://media.railscasts.com/assets/episodes/sources/042-hello-world.zip", :content_length => 4)
    episode.load_file_sizes
    episode.file_sizes.should eq(
      "mp4" => "0",
      "m4v" => "1",
      "webm" => "2",
      "ogv" => "3",
      "zip" => "4"
    )
  end

  it "returns nil as file size when response is not 200" do
    FakeWeb.register_uri(:head, "http://example.com/foo", :content_length => "123", :status => ["404", "Not Found"])
    episode = Factory.build(:episode)
    episode.fetch_file_size("http://example.com/foo").should eq(nil)
  end

  it "has a full name which includes position" do
    Episode.delete_all
    Factory(:episode, :position => 123, :name => "Foo Bar").full_name.should eq('#123 Foo Bar')
  end

  it "knows the next and previous episode based on position" do
    Episode.delete_all
    e1 = Factory(:episode, :position => 1)
    e2 = Factory(:episode, :position => 6)
    e1.previous.should be_nil
    e1.next.should eq(e2)
    e2.next.should be_nil
    e2.previous.should eq(e1)
  end

  describe "primitive search" do
    before(:each) do
      Episode.delete_all
      APP_CONFIG['thinking_sphinx'] = false
    end

    it "looks in name, description, and notes" do
      e1 = Factory(:episode, :name => 'foo', :description => 'bar', :notes => 'baz', :published_at => 2.weeks.ago)
      e2 = Factory(:episode, :name => 'foo test bar', :description => 'baz', :published_at => 2.weeks.ago)
      e3 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.ago)
      Episode.search_published('foo bar baz').should eq([e1, e2])
    end

    it "does not find unpublished" do
      e1 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.ago)
      e2 = Factory(:episode, :name => 'foo', :published_at => 2.weeks.from_now)
      Episode.search_published('foo').should eq([e1])
    end
  end
end
