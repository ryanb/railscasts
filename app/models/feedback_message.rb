class FeedbackMessage < ActiveRecord::Base
  attr_accessible :name, :email, :content
  validates_presence_of :name, :email, :content
end
