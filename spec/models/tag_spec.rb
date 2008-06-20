require File.dirname(__FILE__) + '/../spec_helper'

describe Tag do
  it "should find or create tags with names" do
    Tag.delete_all
    Tag.create!(:name => 'foo')
    tags = Tag.with_names(['foo', 'bar'])
    tags.should have(2).records
    Tag.find(:all).should == tags
  end
end
