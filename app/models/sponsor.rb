class Sponsor < ActiveRecord::Base
  scope :active, where("active = ?", true)
  
  def position
    if force_top?
      rand
    else
      rand + 1
    end
  end
end
