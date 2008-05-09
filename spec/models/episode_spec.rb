require File.dirname(__FILE__) + '/../spec_helper'

describe Episode do
  before(:each) do
    @episode = Episode.new
  end

  it "should be valid" do
    @episode.should be_valid
  end
end
