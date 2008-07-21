require File.dirname(__FILE__) + '/../spec_helper'

describe Download do
  it "should translate single digit seconds into duration with minutes" do
    Download.new(:seconds => 60*8+3).duration.should == '8:03'
  end
  
  it "should translate double digit seconds into duration with minutes" do
    Download.new(:seconds => 60*8+12).duration.should == '8:12'
  end
end
