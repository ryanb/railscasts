class Comment < ActiveRecord::Base
  belongs_to :episode, :counter_cache => true
  
  validates_presence_of :name, :content, :episode_id
  
  named_scope :recent, :order => "created_at DESC"
  
  before_save :add_protocol_to_site_url
  
  acts_as_list :scope => :episode
  
  def request=(request)
    self.user_ip    = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer   = request.env['HTTP_REFERER']
  end
  
  def matching_spam_reports
    conditions = []
    conditions << "comment_ip=#{self.class.sanitize(user_ip)}" unless user_ip.blank?
    conditions << "comment_site_url=#{self.class.sanitize(site_url)}" unless site_url.blank?
    conditions << "comment_name=#{self.class.sanitize(name)}" unless name.blank?
    SpamReport.scoped(:conditions => conditions.join(' or '))
  end
  
  def spammish?
    spam_weight > 5
  end
  
  def spam?
    spam_weight > 50
  end
  
  def spam_weight
     spam_check_weight + spam_report_weight
  end
  
  private
  
  def spam_check_weight
    SpamCheck.all.sum do |spam_check|
      spam_check.weight_for self
    end || 0
  end
  
  def spam_report_weight
    matching_spam_reports.all.sum do |spam_report|
      spam_report.hit_count
    end || 0
  end
  
  def add_protocol_to_site_url
    self.site_url = "http://#{site_url}" unless site_url.blank? || site_url.include?('://')
  end
end
