require File.dirname(__FILE__) + '/../spec_helper'

describe Tagging do
  before(:each) do
    @tagging = Tagging.new
  end

  it "should be valid" do
    @tagging.should be_valid
  end
end
