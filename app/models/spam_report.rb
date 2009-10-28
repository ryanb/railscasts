class SpamReport < ActiveRecord::Base
  belongs_to :comment
  
  before_create :copy_comment_attributes
  
  named_scope :unconfirmed, :conditions => "confirmed_at is null"
  named_scope :confirmed, :conditions => "confirmed_at is not null"
  named_scope :popular, :order => "hit_count desc"
  
  def self.report_comment(comment)
    if comment.matching_spam_reports.empty?
      create!(:comment => comment, :hit_count => 1)
    else
      comment.matching_spam_reports.each do |r|
        r.increment :hit_count
        r.confirmed_at = nil
        r.save!
      end
    end
  end
  
  def matching_comments
    conditions = []
    conditions << "user_ip=#{self.class.sanitize(comment_ip)}" unless comment_ip.blank?
    conditions << "site_url=#{self.class.sanitize(comment_site_url)}" unless comment_site_url.blank?
    conditions << "name=#{self.class.sanitize(comment_name)}" unless comment_name.blank?
    Comment.scoped(:conditions => conditions.join(' or '))
  end
  
  def confirm!
    self.update_attribute(:confirmed_at, Time.now)
    self.matching_comments.each(&:destroy)
  end
  
  private
  
  def copy_comment_attributes
    if comment
      self.comment_site_url = comment.site_url
      self.comment_ip = comment.user_ip
      self.comment_name = comment.name
    end
  end
end
