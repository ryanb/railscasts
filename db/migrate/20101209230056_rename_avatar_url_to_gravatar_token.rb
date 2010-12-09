class RenameAvatarUrlToGravatarToken < ActiveRecord::Migration
  def self.up
    rename_column :users, :avatar_url, :gravatar_token
  end

  def self.down
    rename_column :users, :gravatar_token, :avatar_url
  end
end
