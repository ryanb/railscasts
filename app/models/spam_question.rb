class SpamQuestion < ActiveRecord::Base
  attr_accessible :question, :answer
  
  def self.random # there are more efficient ways to do this but it's database specific
    find(:first, :offset => rand(self.count-1))
  end
end
