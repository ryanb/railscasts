require File.dirname(__FILE__) + '/../spec_helper'

describe Textilizer do
  def textilize(text)
    Textilizer.new(text).to_html
  end
  
  it "should do basic textile" do
    textilize("hello *world*").should == "<p>hello <strong>world</strong></p>"
  end
  
  it "should wrap @@@ in a code block" do
    textilize("@@@\nfoo\n@@@").strip.should == CodeRay.scan('foo', nil).div(:css => :class).strip
  end
  
  it "should not process textile in code block" do
    textilize("@@@\nfoo *bar*\n@@@").strip.should == CodeRay.scan('foo *bar*', nil).div(:css => :class).strip
  end
  
  it "allow language for code block" do
    textilize("@@@ ruby\n@foo\n@@@").strip.should == CodeRay.scan('@foo', 'ruby').div(:css => :class).strip
  end
  
  it "allow code block in the middle" do
    textilize("foo\n@@@\ntest\n@@@\nbar").should include(CodeRay.scan('test', 'ruby').div(:css => :class).strip)
  end
  
  it "should handle \r in code block" do
    textilize("\r\n@@@\r\nfoo\r\n@@@\r\n").strip.should == CodeRay.scan('foo', nil).div(:css => :class).strip
  end
end
