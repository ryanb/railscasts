class User < ActiveRecord::Base
  attr_accessible :name, :email, :site_url
  before_create :generate_token
  has_many :comments

  def self.create_from_omniauth(omniauth)
    User.new.tap do |user|
      user.github_uid = omniauth["uid"]
      user.github_username = omniauth["user_info"]["nickname"]
      user.email = omniauth["user_info"]["email"]
      user.name = omniauth["user_info"]["name"]
      user.site_url = omniauth["user_info"]["urls"]["Blog"] if omniauth["user_info"]["urls"]
      user.gravatar_token = omniauth["extra"]["user_hash"]["gravatar_id"] if omniauth["extra"] && omniauth["extra"]["user_hash"]
      user.save!
    end
  end

  def generate_token
    if token.blank?
      characters = ('a'..'z').to_a + ('A'..'Z').to_a + ('1'..'9').to_a
      begin
        self.token = Array.new(32) { characters.sample }.join
      end while self.class.exists?(:token => token)
    end
  end
end
