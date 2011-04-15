class Comment < ActiveRecord::Base
  belongs_to :episode, :counter_cache => true
  belongs_to :user

  validates_presence_of :content, :episode_id

  scope :recent, order("created_at DESC")

  has_ancestry
  acts_as_list :scope => :episode

  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end
end
