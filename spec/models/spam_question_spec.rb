require File.dirname(__FILE__) + '/../spec_helper'

describe SpamQuestion do
  it "should be valid" do
    SpamQuestion.new.should be_valid
  end
end
