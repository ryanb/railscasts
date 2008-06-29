class Episode < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings
  
  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.now]} }
  
  validates_presence_of :published_at, :name
  
  before_create :set_permalink
  
  def self.by_month
    all.group_by { |e| e.published_at.beginning_of_month }
  end
  
  def tag_names=(names)
    self.tags = Tag.with_names(names.split(/\s+/))
  end
  
  def tag_names
    tags.map(&:name).join(' ')
  end
  
  def to_param
    [id, permalink].join('-')
  end
  
  private
  
  def set_permalink
    self.permalink = name.downcase.gsub(/[^0-9a-z]+/, ' ').strip.gsub(' ', '-') if name
  end
end
