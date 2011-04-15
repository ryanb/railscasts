require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsHelper do
  it "should line break properly" do
    comment = Factory.build(:comment, :content => "foo\nbar\n\nbaz", :legacy => true)
    helper.format_comment(comment).should == "<p>foo\n<br />bar</p>\n\n<p>baz</p>"
  end

  it "should escape html" do
    comment = Factory.build(:comment, :content => "<foo>", :legacy => true)
    helper.format_comment(comment).should == "<p>&lt;foo&gt;</p>"
  end

  it "should use &nbsp; for spaces at beginning of lines" do
    comment = Factory.build(:comment, :content => "  foo bar", :legacy => true)
    helper.format_comment(comment).should == "<p>&nbsp;&nbsp;foo bar</p>"
  end

  it "should use markdown for non-legacy comments" do
    comment = Factory.build(:comment, :content => "**foo**", :legacy => false)
    helper.format_comment(comment).strip.should == "<p><strong>foo</strong></p>"
  end

  it "should add http protocol to url if it doesn't exist" do
    helper.fix_url("foo.com").should == "http://foo.com"
    helper.fix_url("http://foo.com").should == "http://foo.com"
    helper.fix_url("https://foo.com").should == "https://foo.com"
    helper.fix_url("javascript:foo").should == "http://javascript:foo"
  end
end
