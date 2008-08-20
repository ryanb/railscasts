require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  it "should automatically add http to site url upon saving" do
    comment = Factory(:comment, :site_url => 'example.com')
    comment.site_url.should == 'http://example.com'
  end
  
  it "should not add protocol if there already is one" do
    comment = Factory(:comment, :site_url => 'https://example.com')
    comment.site_url.should == 'https://example.com'
  end
  
  it "should not add protocol if site url is blank" do
    comment = Factory(:comment, :site_url => '')
    comment.site_url.should == ''
  end
  
  it "should validate the presence of name, content, and episode_id" do
    comment = Comment.new
    %w[name content episode_id].each do |attr|
      comment.should have(1).error_on(attr)
    end
  end
  
  it "should set request based attributes" do
    comment = Factory.build(:comment, :site_url => 'example.com')
    comment.request = stub(:remote_ip => 'ip', :env => { 'HTTP_USER_AGENT' => 'agent', 'HTTP_REFERER' => 'referrer' })
    comment.user_ip.should == 'ip'
    comment.user_agent.should == 'agent'
    comment.referrer.should == 'referrer'
  end
  
  it "should sort recent comments in descending order by created_at time" do
    Comment.delete_all
    c1 = Factory(:comment, :created_at => 2.weeks.ago)
    c2 = Factory(:comment, :created_at => Time.now)
    Comment.recent.should == [c2, c1]
  end
end
