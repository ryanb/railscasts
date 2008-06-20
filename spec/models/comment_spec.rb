require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  it "should automatically add http to site url upon saving" do
    comment = Comment.create!(:site_url => 'example.com')
    comment.site_url.should == 'http://example.com'
  end
  
  it "should automatically add protocol if there already is one" do
    comment = Comment.create!(:site_url => 'https://example.com')
    comment.site_url.should == 'https://example.com'
  end
end
