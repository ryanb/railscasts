class Sponsor < ActiveRecord::Base
  named_scope :active, :conditions => ["active = ?", true]
  
  def position
    if force_top?
      rand
    else
      rand + 1
    end
  end
end
