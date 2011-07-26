require File.dirname(__FILE__) + '/../spec_helper'

describe CommentsHelper do
  it "handles line breaks properly" do
    comment = Factory.build(:comment, :content => "foo\nbar\n\nbaz", :legacy => true)
    helper.format_comment(comment).should eq("<p>foo\n<br />bar</p>\n\n<p>baz</p>")
  end

  it "escapes html" do
    comment = Factory.build(:comment, :content => "<foo>", :legacy => true)
    helper.format_comment(comment).should eq("<p>&lt;foo&gt;</p>")
  end

  it "uses &nbsp; for spaces at beginning of lines" do
    comment = Factory.build(:comment, :content => "  foo bar", :legacy => true)
    helper.format_comment(comment).should eq("<p>&nbsp;&nbsp;foo bar</p>")
  end

  it "uses markdown for non-legacy comments" do
    comment = Factory.build(:comment, :content => "**foo**", :legacy => false)
    helper.format_comment(comment).strip.should eq("<p><strong>foo</strong></p>")
  end

  it "adds http protocol to url if it doesn't exist" do
    helper.fix_url("foo.com").should eq("http://foo.com")
    helper.fix_url("http://foo.com").should eq("http://foo.com")
    helper.fix_url("https://foo.com").should eq("https://foo.com")
    helper.fix_url("javascript:foo").should eq("http://javascript:foo")
  end
end
