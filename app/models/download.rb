class Download < ActiveRecord::Base
  belongs_to :episode
  
  def duration
    min, sec = *seconds.divmod(60)
    [min, sec.to_s.rjust(2, '0')].join(':')
  end
end
