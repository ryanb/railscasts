require "spec_helper"

describe Tag do
  it "finds or creates tags with names" do
    Tag.delete_all
    Tag.create!(:name => 'foo')
    tags = Tag.with_names(['foo', 'bar'])
    tags.should have(2).records
    Tag.find(:all).should eq(tags)
  end
end
