class SpamCheck < ActiveRecord::Base
  def weight_for(comment)
    (comment.content || "").scan(/#{regexp}/i).size * weight
  end
end
