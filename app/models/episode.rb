class Episode < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings
  has_many :downloads
  
  acts_as_list
  
  named_scope :published, lambda { {:conditions => ['published_at <= ?', Time.now]} }
  named_scope :unpublished, lambda { {:conditions => ['published_at > ?', Time.now]} }
  
  validates_presence_of :published_at, :name
  validates_associated :downloads, :on => :update # create automatically handles validation
  
  before_create :set_permalink
  after_update :save_downloads
  
  def self.by_month
    all.group_by { |e| e.published_at.beginning_of_month }
  end
  
  def mov
    downloads.find_by_format('mov')
  end
  
  def m4v
    downloads.find_by_format('m4v')
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
  
  def last_published?
    self == self.class.published.last
  end
  
  def new_download_attributes=(download_attributes)
    download_attributes.each do |attributes|
      downloads.build(attributes)
    end
  end
  
  def existing_download_attributes=(download_attributes)
    downloads.reject(&:new_record?).each do |download|
      attributes = download_attributes[download.id.to_s]
      if attributes
        download.attributes = attributes
      else
        downloads.delete(download)
      end
    end
  end
  
  private
  
  def save_downloads
    if downloads.loaded?
      downloads.each do |download|
        download.save(false)
      end
    end
  end
  
  def set_permalink
    self.permalink = name.downcase.gsub(/[^0-9a-z]+/, ' ').strip.gsub(' ', '-') if name
  end
end
