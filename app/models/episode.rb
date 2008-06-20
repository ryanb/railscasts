class Episode < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.now]} }
  
  def tag_names=(names)
    self.tags = Tag.with_names(names)
  end
  
  def tag_names
    tags.map(&:name).join(' ')
  end
end
