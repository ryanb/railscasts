require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsHelper do
  it "should line break properly" do
    helper.format_comment("foo\nbar\n\nbaz").should == "<p>foo\n<br />bar</p>\n\n<p>baz</p>"
  end

  it "should escape html" do
    helper.format_comment("<foo>").should == "<p>&lt;foo&gt;</p>"
  end

  it "should use &nbsp; for spaces at beginning of lines" do
    helper.format_comment("  foo bar").should == "<p>&nbsp;&nbsp;foo bar</p>"
  end

  it "should add http protocol to url if it doesn't exist" do
    helper.fix_url("foo.com").should == "http://foo.com"
    helper.fix_url("http://foo.com").should == "http://foo.com"
    helper.fix_url("https://foo.com").should == "https://foo.com"
    helper.fix_url("javascript:foo").should == "http://javascript:foo"
  end
end
