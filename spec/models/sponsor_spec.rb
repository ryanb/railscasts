require File.dirname(__FILE__) + '/../spec_helper'

describe Sponsor do
  it "should find all active sponsors" do
    inactive = Factory.create(:sponsor, :active => false)
    active = Factory.create(:sponsor, :active => true)
    Sponsor.active.should include(active)
    Sponsor.active.should_not include(inactive)
  end
end
