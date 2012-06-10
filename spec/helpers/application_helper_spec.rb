require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  it "encrypts an email address" do
    helper.encrypt_email('foo@bar.com').should eq([102, 111, 111, 64, 98, 97, 114, 46, 99, 111, 109])
  end
end
