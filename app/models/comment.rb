class Comment < ActiveRecord::Base
  belongs_to :episode
  
  validates_presence_of :name, :content, :episode_id
  
  before_save :add_protocol_to_site_url
  
  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end
  
  private
  
  def add_protocol_to_site_url
    self.site_url = "http://#{site_url}" unless site_url.blank? || site_url.include?('://')
  end
end
