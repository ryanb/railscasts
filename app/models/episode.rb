class Episode < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.now]} }
end
