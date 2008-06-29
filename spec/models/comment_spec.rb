require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  it "should automatically add http to site url upon saving" do
    comment = Factory.create(:comment, :site_url => 'example.com')
    comment.site_url.should == 'http://example.com'
  end
  
  it "should automatically add protocol if there already is one" do
    comment = Factory.create(:comment, :site_url => 'https://example.com')
    comment.site_url.should == 'https://example.com'
  end
  
  it "should validate the presence of name, content, and episode_id" do
    comment = Comment.new
    %w[name content episode_id].each do |attr|
      comment.should have(1).error_on(attr)
    end
  end
end
