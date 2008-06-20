class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :episodes, :through => :taggings
end
