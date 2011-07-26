require "spec_helper"

describe Tagging do
  before(:each) do
    @tagging = Tagging.new
  end

  it "is valid" do
    @tagging.should be_valid
  end
end
