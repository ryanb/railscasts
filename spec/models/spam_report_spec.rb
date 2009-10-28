require File.dirname(__FILE__) + '/../spec_helper'

describe SpamReport do
  it "should assign comment attributes to report upon creating" do
    comment = Comment.new(:user_ip => '123.456.789.0', :name => 'foo', :site_url => 'http://example.com')
    report = SpamReport.create!(:comment => comment)
    report.comment_name.should == 'foo'
    report.comment_ip.should == '123.456.789.0'
    report.comment_site_url.should == 'http://example.com'
  end
  
  it "should find matching comments by name, url, or ip" do
    good = Factory(:comment)
    bad = Factory(:comment, :user_ip => '123.456.789.0', :site_url => 'http://foo.example.com', :name => 'spammer!')
    bad_2 = Factory(:comment, :user_ip => bad.user_ip)
    bad_3 = Factory(:comment, :site_url => bad.site_url)
    bad_4 = Factory(:comment, :name => bad.name)
    report = SpamReport.create!(:comment => bad)
    report.matching_comments.should include(bad, bad_2, bad_3, bad_4)
    report.matching_comments.should_not include(good)
  end
  
  it "should not find matching comments by blank values" do
    good = Factory(:comment, :site_url => '', :user_ip => nil, :name => 'gooooood')
    bad = Factory(:comment, :site_url => '', :user_ip => nil, :name => 'baaad')
    report = SpamReport.create!(:comment => bad)
    report.matching_comments.should include(bad)
    report.matching_comments.should_not include(good)
  end
  
  it "should increment hit count when reporting comment spam that already exists and reset confirmation" do
    SpamReport.delete_all # delete so comment doesn't match an older report
    bad = Factory(:comment, :name => 'badbadbad')
    bad_2 = Factory(:comment, :name => 'badbadbad')
    report = SpamReport.report_comment(bad)
    report.reload.hit_count.should == 1
    report.update_attribute(:confirmed_at, Time.now)
    SpamReport.report_comment(bad_2)
    report.reload.hit_count.should == 2
    report.confirmed_at.should be_nil
  end
  
  it "should remove matching comments when confirming" do
    good = Factory(:comment, :name => 'good')
    bad = Factory(:comment, :name => 'bad')
    report = SpamReport.create!(:comment_name => 'bad')
    report.confirm!
    report.confirmed_at.should_not be_nil
    Comment.exists?(bad.id).should be_false
    Comment.exists?(good.id).should be_true
  end
end
