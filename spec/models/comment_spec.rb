require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  it "should validate the presence of episode_id" do
    comment = Comment.new
    %w[episode_id].each do |attr|
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

  it "should add up weight for matching spam checks" do
    SpamReport.delete_all
    SpamCheck.delete_all
    SpamCheck.create!(:regexp => "ugg", :weight => 10)
    SpamCheck.create!(:regexp => "http", :weight => 1)
    Comment.new(:content => "ugghttpHTTP").spam_weight.should == 12
  end

  it "should be spammish when weight is greater than 5" do
    SpamReport.delete_all
    SpamCheck.delete_all
    SpamCheck.create!(:regexp => "a", :weight => 1)
    Comment.new(:content => "aaaaa").should_not be_spammish
    Comment.new(:content => "aaaaaa").should be_spammish
  end

  it "should be spam when weight is greater than 50" do
    SpamReport.delete_all
    SpamCheck.delete_all
    SpamCheck.create!(:regexp => "a", :weight => 10)
    Comment.new(:content => "aaaaa").should_not be_spam
    Comment.new(:content => "aaaaaa").should be_spam
  end

  it "should add matching spam report hits to weight" do
    SpamReport.delete_all
    SpamCheck.delete_all
    SpamCheck.create!(:regexp => "ugg", :weight => 10)
    SpamReport.create!(:comment_name => "Joe", :hit_count => 3)
    Comment.new(:content => "ugg", :name => "Joe").spam_weight.should == 13
  end
end
