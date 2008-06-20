class Episode < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :througth => :taggings
end
