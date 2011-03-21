class Episode < ActiveRecord::Base
  has_many :comments, :dependent => :destroy
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  has_many :downloads, :dependent => :destroy

  acts_as_list

  scope :published, lambda { where('published_at <= ?', Time.now.utc) }
  scope :unpublished, lambda { where('published_at > ?', Time.now.utc) }
  scope :recent, order('position DESC')

  validates_presence_of :published_at, :name
  validates_associated :downloads, :on => :update # create automatically handles validation

  before_create :set_permalink
  after_update :save_downloads

  # sometimes ThinkingSphinx isn't loaded for rake tasks
  if respond_to? :define_index
    define_index do
      indexes :name
      indexes position, :sortable => true
      indexes description
      indexes notes
      indexes comments.content, :as => :comment_content
      indexes tags(:name), :as => :tag_names

      has published_at
    end
  end

  def self.search_published(query)
    if APP_CONFIG['thinking_sphinx']
      search(query, :conditions => { :published_at => 0..Time.now.utc.to_i },
                    :field_weights => { :name => 20, :description => 15, :notes => 5, :tag_names => 10 })
    else
      published.primitive_search(query)
    end
  rescue ThinkingSphinx::ConnectionError => e
    APP_CONFIG['thinking_sphinx'] = false
    raise e
  end

  def self.primitive_search(query)
    find(:all, :conditions => primitive_search_conditions(query))
  end

  def published_month
    published_at.beginning_of_month
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
    [position, permalink].join('-')
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

  def duration
    if seconds
      min, sec = *seconds.divmod(60)
      [min, sec.to_s.rjust(2, '0')].join(':')
    end
  end

  def duration=(duration)
    min, sec = *duration.split(':').map(&:to_i)
    self.seconds = min*60 + sec
  end

  def old?
    self.published_at <= 3.months.ago
  end

  private

  def self.primitive_search_conditions(query)
    query.split(/\s+/).map do |word|
      '(' + %w[name description notes].map { |col| "#{col} LIKE #{sanitize('%' + word.to_s + '%')}" }.join(' OR ') + ')'
    end.join(' AND ')
  end

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
