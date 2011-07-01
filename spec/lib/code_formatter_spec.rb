require File.dirname(__FILE__) + '/../spec_helper'

describe CodeFormatter do
  def format(text)
    CodeFormatter.new(text).to_html
  end

  it "determines language based on file path" do
    formatter = CodeFormatter.new("")
    formatter.language("unknown").should == "unknown"
    formatter.language("hello.rb").should == "ruby"
    formatter.language("hello.js").should == "java_script"
    formatter.language("hello.css").should == "css"
    formatter.language("hello.html.erb").should == "rhtml"
    formatter.language("hello.yml").should == "yaml"
    formatter.language("Gemfile").should == "ruby"
    formatter.language("app.rake").should == "ruby"
    formatter.language("foo.gemspec").should == "ruby"
    formatter.language("rails console").should == "ruby"
    formatter.language("hello.js.rjs").should == "rjs"
    formatter.language("hello.scss").should == "css"
  end

  it "converts to markdown" do
    format("hello **world**").strip.should == "<p>hello <strong>world</strong></p>"
  end

  it "hard wraps return statements" do
    format("hello\nworld").strip.should == "<p>hello<br>\nworld</p>"
  end

  it "autolinks a url" do
    format("http://www.example.com/").strip.should == '<p><a href="http://www.example.com/">http://www.example.com/</a></p>'
  end

  it "formats code block" do
    # This could use some more extensive tests
    format("```\nfoo\n```").strip.should include("<div class=\"code_block\">")
  end

  it "handle back-slashes in code block" do
    # This could use some more extensive tests
    format("```\nf\\'oo\n```").strip.should include("f\\'oo")
  end

  it "does not allow html" do
    format("<img>").strip.should == ""
  end
end
