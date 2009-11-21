require File.dirname(__FILE__) + '/../spec_helper'

describe SpamCheck do
  it "should be valid" do
    SpamCheck.new.should be_valid
  end
end
