class Download < ActiveRecord::Base
  belongs_to :episode
  
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
end
