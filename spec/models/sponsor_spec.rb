require File.dirname(__FILE__) + '/../spec_helper'

describe Sponsor do
  it "should find all active sponsors" do
    inactive = Factory(:sponsor, :active => false)
    active = Factory(:sponsor, :active => true)
    Sponsor.active.should include(active)
    Sponsor.active.should_not include(inactive)
  end
  
  it "should sort force_top first" do
    top_sponsor = Factory(:sponsor, :force_top => true)
    other_sponsor = Factory(:sponsor, :force_top => false)
    [other_sponsor, top_sponsor].sort_by(&:position).first.should == top_sponsor
  end
end
