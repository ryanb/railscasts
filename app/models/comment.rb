class Comment < ActiveRecord::Base
  belongs_to :episode
  
  validates_presence_of :name, :content, :episode_id
  
  before_save :correct_site_url
  
  private
  
  def correct_site_url
    self.site_url = "http://#{site_url}" if site_url && !site_url.include?('://')
  end
end
