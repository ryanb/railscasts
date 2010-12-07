class User < ActiveRecord::Base
  attr_accessible :name, :email, :site_url
  before_create :generate_token

  def self.create_from_omniauth(omniauth)
    User.new.tap do |user|
      user.github_username = omniauth["uid"]
      user.email = omniauth["user_info"]["email"]
      user.name = omniauth["user_info"]["name"]
      user.site_url = omniauth["user_info"]["urls"].values.first if omniauth["user_info"]["urls"]
      user.avatar_url = omniauth["user_info"]["image"]
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
