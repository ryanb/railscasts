class Sponsor < ActiveRecord::Base
  named_scope :active, :conditions => ["active = ?", true]
end
