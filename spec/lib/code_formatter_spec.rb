require File.dirname(__FILE__) + '/../spec_helper'

describe CodeFormatter do
  def format(text)
    CodeFormatter.new(text).to_html
  end

  it "determines language based on file path" do
    formatter = CodeFormatter.new("")
    formatter.language("unknown").should eq("unknown")
    formatter.language("hello.rb").should eq("ruby")
    formatter.language("hello.js").should eq("java_script")
    formatter.language("hello.css").should eq("css")
    formatter.language("hello.html.erb").should eq("rhtml")
    formatter.language("hello.yml").should eq("yaml")
    formatter.language("Gemfile").should eq("ruby")
    formatter.language("app.rake").should eq("ruby")
    formatter.language("foo.gemspec").should eq("ruby")
    formatter.language("rails console").should eq("ruby")
    formatter.language("hello.js.rjs").should eq("rjs")
    formatter.language("hello.scss").should eq("css")
    formatter.language("rails").should eq("ruby")
    formatter.language("foo.bar ").should eq("bar")
    formatter.language("foo ").should eq("foo")
    formatter.language("").should eq("text")
    formatter.language(nil).should eq("text")
    formatter.language("0```").should eq("text")
  end

  it "converts to markdown" do
    format("hello **world**").strip.should eq("<p>hello <strong>world</strong></p>")
  end

  it "hard wraps return statements" do
    format("hello\nworld").strip.should eq("<p>hello<br>\nworld</p>")
  end

  it "autolinks a url" do
    format("http://www.example.com/").strip.should eq('<p><a href="http://www.example.com/">http://www.example.com/</a></p>')
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
    format("<img>").strip.should eq("")
  end
end
