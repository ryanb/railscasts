require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  before(:each) do
    @tag = Tag.new
  end
  
  it "should be valid" do
    @tag.should be_valid
  end
end
