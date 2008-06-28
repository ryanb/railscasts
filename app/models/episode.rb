class Episode < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.now]} }
  
  validates_presence_of :published_at
  
  def self.by_month
    all.group_by { |e| e.published_at.beginning_of_month }
  end
  
  def tag_names=(names)
    self.tags = Tag.with_names(names)
  end
  
  def tag_names
    tags.map(&:name).join(' ')
  end
end
